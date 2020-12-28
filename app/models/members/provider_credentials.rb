module Members
  class ProviderCredentials
    def self.for(member)
      new(member).lookup
    end

    def initialize(member)
      @member = member
    end

    def lookup
      member.auth_credential
    end

    private

    attr_accessor :member

    def company
      @_company ||= member.company
    end
  end
end
