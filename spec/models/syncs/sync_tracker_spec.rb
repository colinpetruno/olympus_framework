require "rails_helper"

RSpec.describe ::Syncs::SyncTracker, type: :model do
  before(:each) do
    @session_info = default_session_info

    @calendar = create_calendar_for(
      @session_info.member,
      count: 1,
      options: {}
    ).first

    @sync_tracker = ::Syncs::SyncTracker.new(
      syncable: @calendar,
      provider: @calendar.provider,
      sync_log: nil,
      sync_base_class: "Syncs::CalendarEventsSync"
    )
  end

  describe "#start!" do
    it "should create a sync log if it does not exist" do
      SyncLog.delete_all

      expect(SyncLog.all.count).to eql(0)
      @sync_tracker.start!

      expect(SyncLog.all.count).to eql(1)
    end

    it "should set the sync log time to now and put it in progress" do
      @sync_log = SyncLogs::Creator.new(
        status: :queued,
        base_class: "Syncs::CalendarEventsSync",
        session_info: @session_info,
        syncable: @calendar
      ).create

      tracker = ::Syncs::SyncTracker.new(
        syncable: @calendar,
        provider: @calendar.provider,
        sync_log: @sync_log,
        sync_base_class: "Syncs::CalendarEventsSync"
      )

      expect(tracker.sync_log.time_start).to be_nil
      tracker.start!
      expect(tracker.sync_log.time_start).to_not be_nil
    end
  end

  describe "#finish!" do
    it "should update the sync log with appropriate duration and status" do
      Timecop.freeze
      @sync_tracker.start!

      sync_log = @sync_tracker.sync_log
      expect(sync_log.elapsed_time).to eql(0)
      expect(sync_log.sync_status).to eql("in_progress")

      Timecop.travel(DateTime.now + 5.minutes)

      @sync_tracker.finish!(:succeeded)

      expect(sync_log.elapsed_time).to eql(300)
      expect(sync_log.sync_status).to eql("succeeded")
      Timecop.return
    end
  end

  describe "#next_page!" do
    it "should increment total_pages by one" do
      expect(@sync_tracker.sync_log.total_pages).to eql(0)
      @sync_tracker.next_page!
      expect(@sync_tracker.sync_log.total_pages).to eql(1)
    end
  end

  describe "#log and #log_output" do
    it "should record and output the log" do
      @sync_tracker.log("aaa")
      @sync_tracker.log("ccc")
      @sync_tracker.log("bbb")

      result = @sync_tracker.log_output

      expect(result).to eql("aaa\nccc\nbbb")
    end
  end

  describe "#increment_counter and #increment_count" do
    it "should accurately track the success and failures" do
      event_mock = CalendarEvent.new
      @sync_tracker.increment_counter(true, event_mock)
      @sync_tracker.increment_counter(true, event_mock)
      @sync_tracker.increment_counter(false, event_mock)
      @sync_tracker.increment_counter(true, event_mock)
      @sync_tracker.increment_counter(false, event_mock)

      expect(@sync_tracker.imported_count).to eql(3)
      expect(@sync_tracker.failed_count).to eql(2)
    end
  end
end
