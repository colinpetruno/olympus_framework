module Authentication
  class AddNewCredential
    # this class is used for the first connection from google oauth
    # but not subsequent events
    def self.for(oauth_response)
      new(oauth_response).create
    end

    def initialize(oauth_response)
      @oauth_response = oauth_response
    end

    # Returns: AuthCredential that has been updated with the latest info
    def create
      Authentication::CredentialsUpdaterFromParams.new(
        auth_credential: auth_credential,
        params: {
          provider: oauth_response.provider,
          token: oauth_response.token,
          refresh_token: oauth_response.refresh_token,
          expires: oauth_response.expires?,
          expires_at: oauth_response.expires_at,
          account_name: oauth_response.email.downcase.strip
        }
      ).update
    end

    private

    attr_reader :oauth_response

    def auth_credential
      @_auth_credential ||= member.auth_credentials.build
    end

    def member
      @_member ||= Members::Finder.by_email!(lookup_email)
    end

    def lookup_email
      # if session info is present then they were already logged in at the
      # point of initial connection. Therefore use the logged in email to
      # tie the credental to instead of the account they just authed with.
      # if session_info is nil then we know its a completely new account
      if oauth_response.session_info.present?
        oauth_response.session_info.member.email
      else
        raise StandardError.new(
          "Credential addition failed for logged out member"
        )
      end
    end
  end
end
