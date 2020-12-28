require "rails_helper"

RSpec.describe Profile, type: :model do
  describe "#full_name" do
    it "should combine the names without adding errant spaces" do
      profile = Profile.new(family_name: "Fluffy", given_name: "Pascal")

      # NOTE: We join this with a nbsp so typing a space will cause a failure
      # this is to ensure the combined name always renders on the same line
      expected_name = ["Pascal", "Fluffy"].compact.join([160].pack('U*'))

      expect(profile.full_name).to eql(expected_name)
      profile.given_name = nil
      expect(profile.full_name).to eql("Fluffy")

      profile.given_name = "Pascal"
      profile.family_name = nil
      expect(profile.full_name).to eql("Pascal")
    end
  end

  describe "#valid?" do
    it "should ve in a valid state" do
      session_info = default_session_info
      profile = session_info.profile

      profile.should validate_presence_of(:family_name)
      profile.should validate_presence_of(:given_name)
    end
  end
end
