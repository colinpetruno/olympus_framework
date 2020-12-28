module Authentication
  class CredentialRemover
    def self.for(auth_credential)
      new(auth_credential).remove
    end

    def initialize(auth_credential)
      @auth_credential = auth_credential
    end

    def remove
      ApplicationRecord.transaction do
        AuthCredentialLog.create(
          provider: auth_credential.provider,
          member_id: auth_credential.member_id,
          token: auth_credential.token,
          refresh_token: auth_credential.refresh_token,
          expires: auth_credential.expires,
          expires_at: auth_credential.expires_at
        )

        auth_credential.destroy
      end
    end

    private

    attr_reader :auth_credential
  end
end
