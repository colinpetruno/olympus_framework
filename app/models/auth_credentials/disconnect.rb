module AuthCredentials
  class Disconnect
    def self.for(auth_credential)
      new(auth_credential).disconnect
    end

    def initialize(auth_credential)
      @auth_credential = auth_credential
    end

    def disconnect
      ::Authentication::Revoker.for(auth_credential)
      ::Authentication::CredentialRemover.for(auth_credential)

      ::Calendars::Remover.for_provider(
        session_info,
        auth_credential.provider
      )

      true
    rescue StandardError => error
      Errors::Reporter.notify(error)

      false
    end

    private

    attr_reader :auth_credential

    def session_info
      @_session_info ||= ::Members::SessionInfo.by_id(
        auth_credential.member_id
      )
    end
  end
end
