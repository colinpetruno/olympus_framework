module Authentication
  class Revoker
    REVOKERS = {
      google_oauth2: Authentication::Revokers::Google
    }.freeze

    def self.for(auth_credential)
      new(auth_credential).revoke
    end

    def initialize(auth_credential)
      @auth_credential = auth_credential
    end

    def revoke
      REVOKERS[auth_credential.provider.to_sym].revoke(auth_credential)
    end

    private

    attr_reader :auth_credential
  end
end
