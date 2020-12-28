require "rails_helper"

RSpec.describe Authentication::OauthResponse::Google, type: :model do
  describe "given a response from google" do
    def json
      @_json ||= JSON.parse(
        File.read(
          Rails.root.join("spec/support/files/google_auth_response.json")
        )
      )
    end

    it "should return the proper values from the hash" do
      auth = Authentication::OauthResponse::Google.new(json)

      expect(auth.info.email).to eql("colin@meettrics.com")
      expect(auth.info.family_name).to eql("Petruno")
      expect(auth.info.given_name).to eql("Colin")
      expect(auth.info.picture_url).to eql("fake_image_url")

      expect(auth.credentials.token).to eql("dummy_token")
      expect(auth.credentials.refresh_token).to eql("dummy_refresh_token")
      expect(auth.credentials.expires?).to eql(true)
      expect(auth.credentials.expires_at).to eql(1572088456)
    end
  end
end
