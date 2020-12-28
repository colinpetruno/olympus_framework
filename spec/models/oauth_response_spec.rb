require "rails_helper"

RSpec.describe Authentication::OauthResponse, type: :model do
  describe "given a omniauth response hash" do
    def json
      @_json ||= JSON.parse(
        File.read(
          Rails.root.join("spec/support/files/google_auth_response.json")
        )
      )
    end

    it "should instantiate the right response class" do
      auth = Authentication::OauthResponse.new(json)

      expect(auth.provider_adaptor.class.name).
        to eql("Authentication::OauthResponse::Google")
    end

    it "should raise an error if it is an invalid provider" do
      json["provider"] = "invalid_provider"

      expect {
        Authentication::OauthResponse.for(json).provider_adaptor
      }.to raise_error(Authentication::OauthResponse::Error)
    end

    describe "#given_name" do
      it "should return the persons firstname" do
        auth = Authentication::OauthResponse.for(json)

        expect(auth.given_name).to eql("Colin")
      end
    end

    describe "#given_name" do
      it "should return the persons firstname" do
        auth = Authentication::OauthResponse.for(json)

        expect(auth.given_name).to eql("Colin")
      end
    end

    describe "#family_name" do
      it "should return the persons family name" do
        auth = Authentication::OauthResponse.for(json)

        expect(auth.family_name).to eql("Petruno")
      end
    end

    describe "#token" do
      it "should return the auth token" do
        auth = Authentication::OauthResponse.for(json)

        expect(auth.token).to eql("dummy_token")
      end
    end

    describe "#refresh_token" do
      it "should return the auth token" do
        auth = Authentication::OauthResponse.for(json)

        expect(auth.refresh_token).to eql("dummy_refresh_token")
      end
    end

    describe "#picture_url" do
      it "should return the photo url if present" do
        auth = Authentication::OauthResponse.for(json)

        expect(auth.picture_url).to eql("fake_image_url")
      end
    end

    describe "#email" do
      it "should return the persons email address" do
        auth = Authentication::OauthResponse.for(json)

        expect(auth.email).to eql("colin@meettrics.com")
      end

      it "should downcase the email" do
        modified_json = json
        modified_json["info"]["email"] = "ColIN@meeTtricS.coM"

        auth = Authentication::OauthResponse.for(modified_json)

        expect(auth.email).to eql("colin@meettrics.com")
      end
    end
  end
end
