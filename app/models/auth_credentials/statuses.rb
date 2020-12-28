module AuthCredentials
  class Statuses
    def self.for(session_info, auth_credentials)
      new(session_info, auth_credentials).lookup
    end

    def initialize(session_info, auth_credentials)
      @auth_credentials = auth_credentials
      @session_info = session_info
    end

    def lookup
      auth_credentials.map do |auth_credential|
      ::AuthCredentials::Status.new(
        provider: auth_credential.provider,
          auth_credential: auth_credential,
          broken_auth_record: broken_credential_for(auth_credential)
        )
      end
    end

    private

    attr_reader :auth_credentials, :session_info

    def broken_credential_for(auth_credential)
      broken_credentials.to_a.find do |broken_credential|
        broken_credential.auth_credential_id == auth_credential.id
      end
    end

    def broken_credentials
      @_broken_credentials ||= BrokenAuthRecord.where(
        member_id: session_info.member.id,
        reconnected_at: nil
      )
    end
  end
end
