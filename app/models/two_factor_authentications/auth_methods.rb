module TwoFactorAuthentications
  class AuthMethods
    def self.for(member)
      new(member).find
    end

    def initialize(member)
      @member = member
    end

    def find
      TwoFactorAuthentication.
        where(member: member, enabled: true).
        pluck(:auth_type).
        uniq
    end

    private

    attr_reader :member
  end
end
