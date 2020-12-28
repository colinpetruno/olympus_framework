require "rails_helper"

RSpec.describe Utilities::DomainFromEmail, type: :model do
  describe "#domain" do
    it "should return only domain" do
      result = Utilities::DomainFromEmail.for("mehdjfkj@example.com")

      expect(result).to eql("example.com")
    end
  end
end
