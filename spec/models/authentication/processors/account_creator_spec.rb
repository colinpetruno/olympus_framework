require "rails_helper"

RSpec.describe Authentication::Processors::AccountCreator, type: :model do
  def json
    JSON.parse(
      File.read(
        Rails.root.join('spec/support/files/google_auth_response.json')
      )
    )
  end

  describe '#create' do
    it 'should downcase email addresses' do
      modified_json = json
      modified_json['info']['email'] = 'ColIN@meeTtricS.coM'

      oauth_response = Authentication::OauthResponse.new(
        modified_json
      )

      result = Authentication::Processors::AccountCreator.for(
        oauth_response
      )

      expect(result[:member].email).to eql('colin@meettrics.com')
      expect(result[:member].profile.email).to eql('colin@meettrics.com')
    end

    it 'should make the account creator an admin' do
      oauth_response = Authentication::OauthResponse.new(json)
      result = Authentication::Processors::AccountCreator.for(oauth_response)

      expect(result[:member].profile.role.to_sym).to eql(:company_admin)
    end

    it 'should fill out the provider' do
      oauth_response = Authentication::OauthResponse.new(json)
      result = Authentication::Processors::AccountCreator.for(oauth_response)

      expect(result[:company].provider).to eql('google_oauth2')
    end
  end
end
