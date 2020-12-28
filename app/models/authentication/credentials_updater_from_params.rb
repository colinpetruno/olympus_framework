module Authentication
  class CredentialsUpdaterFromParams
    def initialize(auth_credential:, params:)
      @auth_credential = auth_credential
      @params = params
    end

    def update
      if auth_credential.persisted?
        rotate_auth_credential
      end

      create_or_update_auth_credential

      auth_credential
    end

    private

    attr_reader :auth_credential, :params

    def rotate_auth_credential
      # it's important to access the accessors so that the data is decrypted
      # and reencrypted under a new key
      AuthCredentialLog.create(
        provider: auth_credential.provider,
        member_id: auth_credential.member_id,
        token: auth_credential.token,
        refresh_token: auth_credential.refresh_token,
        expires: auth_credential.expires,
        expires_at: auth_credential.expires_at
      )
    end

    def create_or_update_auth_credential
      # Google only returns a refresh token on the first request and then no
      # longer passes it. Thus this hash is being compacted before it's
      # assigned so that we don't accidently nil out the refresh token.
      auth_credential.update(params.compact)
    end
  end
end
