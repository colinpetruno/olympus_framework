require 'rails_helper'

RSpec.describe Authentication::Action, type: :model do
  def new_omniauth_response
    Authentication::OauthResponse.new(
      JSON.parse(
        File.read(
          Rails.root.join('spec/support/files/google_auth_response.json')
        )
      )
    )
  end

  describe '#action_name' do
    it 'should login if the email already exists in the system' do
      company = Company.create(
        email_domain: 'meettrics.com',
        name: 'meettrics.com',
        open_signups: :allowed,
        provider: 'google_oauth2'
      )

      member = Member.create(
        email: 'colin@meettrics.com',
        company: company,
        profile_attributes: {
          company: company,
          email: 'colin@meettrics.com',
          given_name: 'Colin',
          family_name: 'Petruno',
          timezone: 'UTC',
          external_slug: SecureRandom.uuid
        }
      )

      action = Authentication::Action.for(new_omniauth_response)
      expect(action.action_name).to eql(:login)
    end

    it 'connects the account if the company exists and the member does not' do
      company = Company.create(
        email_domain: 'meettrics.com',
        name: 'meettrics.com',
        open_signups: :allowed,
        provider: 'google_oauth2'
      )

      Member.create(
        email: 'test@meettrics.com',
        company: company
      )

      action = Authentication::Action.for(new_omniauth_response)
      expect(action.action_name).to eql(:connect)
    end

    it 'requests invite if the company is closed for domain signups' do
      company = Company.create(
        email_domain: "meettrics.com",
        name: 'meettrics.com',
        open_signups: :invite,
        provider: 'google_oauth2'
      )

      Member.create(
        email: 'meettrics.com',
        company: company,
        profile_attributes: {
          company: company,
          email: 'colin@meettrics.com',
          given_name: 'Colin',
          family_name: 'Petruno',
          timezone: 'UTC',
          external_slug: SecureRandom.uuid
        }
      )

      action = Authentication::Action.for(new_omniauth_response)
      expect(action.action_name).to eql(:create_account)
    end

    it "creates an account if no company or member exists" do
      action = Authentication::Action.for(new_omniauth_response)
      expect(action.action_name).to eql(:create_account)
    end
  end

  describe "#redirect_path" do
    it 'redirects to the connect page when when the company exists' do
      pending('needs route created yet')
      company = Company.create(
        email_domain: 'meettrics.com',
        name: 'meettrics.com',
        open_signups: :allowed,
        provider: 'google_oauth2'
      )

      action = Authentication::Action.for(new_omniauth_response)
      expect(action.redirect_path).to eql(dashboard_root_path)
    end

    it 'asks for an invite when the company exists and signups are closed' do
      pending('needs route created yet')
      company = Company.create(
        email_domain: "meettrics.com",
        name: 'meettrics.com',
        open_signups: :allowed,
        provider: 'google_oauth2'
      )

      action = Authentication::Action.for(new_omniauth_response)
      expect(action.redirect_path).to eql(dashboard_root_path)
    end

    it 'redirects to the onboarding after creating an account' do
      action = Authentication::Action.for(new_omniauth_response)

      expect(
        action.redirect_path
      ).to eql(
        dashboard_onboarding_company_settings_path
      )
    end
  end
end
