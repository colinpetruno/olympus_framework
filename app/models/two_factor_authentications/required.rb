module TwoFactorAuthentications
  class Required
    def self.for?(member)
      new(member).required?
    end

    def initialize(member)
      @member = member
    end

    def required?
      member.application_admin?
    end

    private

    attr_reader :member
  end
end
