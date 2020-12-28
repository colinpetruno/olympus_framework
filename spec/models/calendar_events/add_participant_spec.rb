require "rails_helper"

RSpec.describe CalendarEvents::AddParticipant, type: :model do
  before(:each) do
    @session_info = default_session_info
    @calendar = create_calendar_for(@session_info.member, options: {}).first
    @event = @calendar.calendar_events.last
  end

  describe "#add" do
    it "should add a new person" do
      expect(@event.event_participants.length).to eql(1)

      attendee = Syncs::AttendeeDecoratorMock.new

      CalendarEvents::AddParticipant.new(
        calendar_event: @event,
        session_info: @session_info
      ).add(attendee)

      expect(@event.event_participants.reload.length).to eql(2)
    end

    context "for an existing person" do
      it "should not add another record" do
        expect(@event.event_participants.length).to eql(1)

        attendee = Syncs::AttendeeDecoratorMock.from_event_participant(
          @event.event_participants.first
        )

        # ensure that we in fact do call the update participant here since we
        # don't necessarily know if any of the properties have changed
        expect(CalendarEvents::UpdateParticipant).to receive(:for)

        CalendarEvents::AddParticipant.new(
          calendar_event: @event,
          session_info: @session_info
        ).add(attendee)

        expect(@event.event_participants.reload.length).to eql(1)
      end

      it "should not log any attributes if nothing changed" do
        expect(@event.event_participants.length).to eql(1)

        participant = @event.event_participants.first

        attendee = Syncs::AttendeeDecoratorMock.from_event_participant(
          participant
        )

        CalendarEvents::AddParticipant.new(
          calendar_event: @event,
          session_info: @session_info
        ).add(attendee)

        expect(participant.event_participant_changes.length).to eql(0)
        expect(participant.event_participant_actions.length).to eql(0)
      end

      it "should track the changes approprioptely" do
        expect(@event.event_participants.length).to eql(1)

        participant = @event.event_participants.first

        attendee = Syncs::AttendeeDecoratorMock.from_event_participant(
          participant
        )

        status_keys = EventParticipant.response_statuses.keys
        new_status = (status_keys - [attendee.response_status.to_s]).sample

        # email is the unique key so to speak so it must stay the same
        adjusted_attendee = Syncs::AttendeeDecoratorMock.new(
          email: attendee.email,
          display_name: "Pascal Fluffy",
          response_status: new_status,
          optional: !attendee.optional?,
          organizer: !attendee.organizer?,
        )

        CalendarEvents::AddParticipant.new(
          calendar_event: @event,
          session_info: @session_info
        ).add(adjusted_attendee)

        expect(participant.event_participant_changes.length).to eql(3)
        expect(participant.event_participant_actions.length).to eql(1)
      end
    end
  end
end
