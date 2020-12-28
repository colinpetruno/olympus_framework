require "rails_helper"

RSpec.describe AuthCredentialLog, type: :model do
  describe "#valid?" do
    it "should ensure expiration date if the token expires" do
      auth_credential = AuthCredentialLog.new(
        provider: "google_oauth2",
        member_id: 1,
        token: "asdf",
        refresh_token: "qwer",
        expires: true
      )

      expect(auth_credential.valid?).to eql(false)
    end
  end
end
