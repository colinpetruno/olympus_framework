module Authentication
  class Status
    def self.for(session_info)
      new(session_info).status
    end

    def new(session_info)
      @session_info = session_info
    end

    def status
      :disconnected if auth_credential_is_blank?
    end

    private

    attr_reader :session_info

    def auth_credential
      @_auth_credential ||= somethign
    end

    def auth_credential_is_blank?
      session_info.member
    end
  end
end
