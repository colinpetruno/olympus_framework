module AuthCredentials
  class ErrorHandler
    def self.for(auth_credential, error)
      new(auth_credential, error).handle_error
    end

    def initialize(auth_credential, error)
      @auth_credential = auth_credential
      @error = error
    end

    def handle_error
      BrokenAuthRecord.create(
        auth_credential: auth_credential,
        provider: auth_credential.provider,
        member_id: auth_credential.member_id,
        error_type: error["error"],
        error_message: error["error_description"],
        disconnected_at: DateTime.now
      )

      ::Authentication::CredentialRemover.for(auth_credential)
    end

    private

    attr_reader :auth_credential, :error
  end
end
