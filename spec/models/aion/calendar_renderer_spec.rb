require "rails_helper"

RSpec.describe Aion::CalendarRenderer, type: :model do
  describe "#render_calendar" do
    it "should raise an error if given an invalid type" do
      renderer = Aion::CalendarRenderer.new(
        settings: Aion::CalendarSettings.new(
          display_format: :millennium
        )
      )

      expect {
          renderer.render_calendar
      }.to raise_error(
        Aion::Errors::InvalidDisplayFormat,
        I18n.t(
          "aion.errors.invalid_display_format",
          invalid_type: "millennium"
        )
      )
    end
  end
end
