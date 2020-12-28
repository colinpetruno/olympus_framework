require "rails_helper"

RSpec.describe EventParticipants::LookupKey, type: :model do
  describe "#key" do
    it "should be type then id, seperated by a colon" do
      participant = EventParticipant.new(
        participatable_type: "Profile",
        participatable_id: 1
      )

      result = EventParticipants::LookupKey.for(participant)

      expect(result).to eql("Profile:1")
    end
  end
end
