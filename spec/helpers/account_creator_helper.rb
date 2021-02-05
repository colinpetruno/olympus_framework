module AccountCreatorHelper
  def default_session_info
    return @session_info if @session_info.present?

    json = JSON.parse(
        File.read(
            Rails.root.join('spec/support/files/google_auth_response.json')
          )
      )

    oauth_response = Authentication::OauthResponse.new(json)
    result = Authentication::Processors::AccountCreator.for(oauth_response)
    @session_info = Members::SessionInfo.for(result[:member])
    @session_info
  end

  def default_team
    @_default_team ||= default_session_info.profile.team
  end

  def default_company
    @_default_company ||= default_session_info.company
  end

  def session_info_custom_data(options = { member: {}, company: {} })
    random_id = SecureRandom.uuid
    default_settings = {
        member: {
            email: "test_member_#{random_id}@example.com"
        },
        company: {
            email_domain: "#{random_id}_example.com",
            name: "#{random_id}_example.com",
            auth_credential_id: nil,
            open_signups: true,
            provider: 'google_oauth2'
        }
    }

    result = Accounts::Creator.for(default_settings.deep_merge(options))

    Members::SessionInfo.for(result[:member])
  end

  def create_member(attributes = {})
    email = "pascalfluffy-#{SecureRandom.uuid}@example.com"

    Member.create({
        email: email,
        company: default_company,
        profile_attributes: {
            email: email,
            company: default_company,
            team: default_team,
            role: :company_admin,
            timezone: 'UTC',
            given_name: "Pascal-#{(1..100).to_a.sample}",
            family_name: "Fluffy-#{(1..100).to_a.sample}",
            external_slug: SecureRandom.uuid
        }
    }.deep_merge(attributes))
  end
end
