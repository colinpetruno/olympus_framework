require "rails_helper"

RSpec.describe Calendars::Finder, type: :model do
  describe "#find" do
    it "should not return deleted records" do
      session_info = default_session_info

      create_calendar_for(session_info.member, options: {})
      create_calendar_for(session_info.member, options: {
        deleted_at: 2.weeks.ago
      })

      finder = Calendars::Finder.new(session_info)
      expect(finder.find.length).to eql(1)
    end
  end

  describe "#find_with_deleted" do
    it "should return deleted records" do
      session_info = default_session_info

      create_calendar_for(session_info.member, options: {})
      create_calendar_for(session_info.member, options: {
        deleted_at: 2.weeks.ago
      })

      finder = Calendars::Finder.new(session_info)
      expect(finder.find_with_deleted.length).to eql(2)
    end
  end

  describe "#alphabetical" do
    it "should order records by name" do
      session_info = default_session_info
      create_calendar_for(session_info.member, options: { name: "qqq" })
      create_calendar_for(session_info.member, options: { name: "zzz" })
      create_calendar_for(session_info.member, options: { name: "aaa" })
      create_calendar_for(session_info.member, options: { name: "rrr" })

      calendars = Calendars::Finder.new(session_info).alphabetical

      expect(calendars.length).to eql(4)
      expect(calendars.first.name).to eql("aaa")
      expect(calendars.second.name).to eql("qqq")
      expect(calendars.third.name).to eql("rrr")
      expect(calendars.fourth.name).to eql("zzz")
    end
  end
end
