require "rails_helper"

RSpec.describe ::Syncs::Google::CalendarEventsSync, type: :model do
  describe "#sync" do
    it "should create a sync log" do
      session_info = default_session_info

      calendar = create_calendar_for(
        session_info.member,
        count: 1,
        options: {}
      ).first

      Syncs::Google::CalendarEventsSync.new(
        calendar: calendar,
        session_info: session_info,
        importer_class: ::Syncs::Google::EventImporterMock,
        lister_class: ::ExternalResources::Google::Events::ListMock
      ).sync

      sync_log = SyncLog.last

      expect(sync_log.succeeded_count).to eql(14)
      expect(sync_log.failed_count).to eql(0)
      expect(sync_log.sync_status).to eql("succeeded")
      expect(sync_log.time_end).to_not be_nil
      expect(sync_log.elapsed_time).to_not be_nil
    end
  end
end
