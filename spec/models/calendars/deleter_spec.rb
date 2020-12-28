require "rails_helper"

RSpec.describe Calendars::Deleter, type: :model do
  describe "#delete" do
    it "should delete a single record" do
      session_info = default_session_info

      calendar = create_calendar_for(session_info.member, options: {}).first
      create_calendar_for(session_info.member, options: {
        deleted_at: 2.weeks.ago
      })

      expect(calendar.deleted_at).to be_nil
      deleter = Calendars::Deleter.new(session_info)
      result = deleter.delete(calendar.external_id, "google_oauth2")
      expect(result.length).to eql(1)
      expect(calendar.reload.deleted_at).not_to be_nil
    end

    it "should accept multiple ids" do
      session_info = default_session_info

      create_calendar_for(session_info.member, options: {}).first
      create_calendar_for(session_info.member, options: {
        deleted_at: 2.weeks.ago
      })

      deleter = Calendars::Deleter.new(session_info)
      result = deleter.delete(Calendar.all.map(&:external_id), "google_oauth2")
      # ensure both objects are returned
      expect(result.length).to eql(2)

      # ensure there are 2 non nil values in deleted_at
      deleted_ats = Calendar.all.pluck(:deleted_at).reject(&:blank?)
      expect(deleted_ats.length).to eql(2)
    end
  end
end
