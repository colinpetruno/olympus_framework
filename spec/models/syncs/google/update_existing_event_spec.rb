require "rails_helper"

RSpec.describe Syncs::Google::UpdateExistingEvent, type: :model do
  before(:each) do
    @session_info = default_session_info
    @calendar = create_calendar_for(@session_info.member, options: {}).first
    @event = @calendar.calendar_events.last

    @existing_event = ::Syncs::Unifiers::CalendarEventMock.from_meettrics(
      @event
    )

    @updated_event = ::Syncs::Unifiers::CalendarEventMock.from_meettrics(
      @event
    )
  end

  describe "#update" do
    it "should log the proper changes" do
      @updated_event.event_name = "New name #{SecureRandom.uuid}"

      Syncs::Google::UpdateExistingEvent.for(@updated_event, @existing_event)

      expect(@event.calendar_event_changes.reload.length).to eql(1)
    end

    context "when the start time changes" do
      it "should insert a new event" do
        expect(@calendar.calendar_events.length).to eql(1)
        expect(@event.deleted_at).to be_nil

        @updated_event.start_time = @updated_event.start_time + 30.minutes
        @updated_event.object = ::Google::EventMock.new(
          event_unifier: @updated_event
        )

        Syncs::Google::UpdateExistingEvent.for(@updated_event, @existing_event)

        @event.reload

        expect(@event.most_recent).to be(false)
        expect(@calendar.calendar_events.reload.length).to eql(2)
      end
    end
  end
end
