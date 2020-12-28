module Authentication
  class CredentialsUpdater
    # this class is used for the first connection from google oauth
    def self.for(oauth_response)
      new(oauth_response).create_or_update
    end

    def initialize(oauth_response)
      @oauth_response = oauth_response
    end

    # Returns: AuthCredential that has been updated with the latest info
    def create_or_update
      Authentication::CredentialsUpdaterFromParams.new(
        auth_credential: auth_credential,
        params: {
          provider: oauth_response.provider,
          token: oauth_response.token,
          refresh_token: oauth_response.refresh_token,
          expires: oauth_response.expires?,
          expires_at: oauth_response.expires_at
        }
      ).update
    end

    private

    attr_reader :oauth_response

    def auth_credential
      @_auth_credential ||= find_or_build_auth_credential
    end

    def find_or_build_auth_credential
      member.auth_credential || member.build_auth_credential(account_name: oauth_response.email)
    end

    def member
      @_member ||= Members::Finder.by_email!(oauth_response.email)
    end
  end
end
