require "rails_helper"

RSpec.describe Aion::Renderers::Week, type: :model do
  describe "#dates" do
    it "should return the beginning of the week as a monday if not specified" do
      date = Date.parse("20200218")

      Timecop.freeze(date)

      renderer = Aion::Renderers::Week.new(
        calendar_name: "demo"
      )

      expect(renderer.dates.first.strftime("%Y%m%d")).to eql("20200217")
      expect(renderer.dates.last.strftime("%Y%m%d")).to eql("20200223")

      Timecop.return
    end

    it "should return the proper start date if specified" do
      date = DateTime.parse("20200218").utc

      Timecop.freeze(date)

      renderer = Aion::Renderers::Week.new(
        calendar_name: "demo",
        start_day: :wednesday
      )

      expect(renderer.dates.first.strftime("%Y%m%d")).to eql("20200212")
      expect(renderer.dates.last.strftime("%Y%m%d")).to eql("20200218")

      Timecop.return
    end
  end
end
