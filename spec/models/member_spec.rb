require "rails_helper"

RSpec.describe Member, type: :model do
  describe "#email=" do
    it "should fill out the hashed email" do
      test_email = "pascalfloofy@example.com"
      hashed_email = Digest::SHA2.new(512).hexdigest(test_email)

      m = Member.new
      m.email = test_email

      expect(m.hashed_email).to be_nil
      m.valid?
      expect(m.hashed_email).to eql(hashed_email)
    end
  end
end
