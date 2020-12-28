module Authentication::Processors
  class AddProvider
    def self.for(oauth_response)
      new(oauth_response).add
    end

    def initialize(oauth_response)
      @oauth_response = oauth_response
    end

    def add
      Authentication::AddNewCredential.for(oauth_response)

      return true
      ::Syncs::Queuer.new(
        ::Members::SessionInfo.for(result[:member])
      ).queue(
        "Syncs::MemberCalendarSync",
        result[:member].auth_credentials.first
      )
    end

    private

    attr_reader :oauth_response

    def member_for_credential
      return nil if oauth_response.session_info.nil?

      oauth_response.session_info.member
    end
  end
end
