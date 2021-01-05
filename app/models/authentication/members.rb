module Authentication
  class Members
    def self.confirm(member)
      new(member).confirm
    end

    def initialize(member)
      @member = member
    end

    def confirm
      member.confirm
    end

    private

    attr_reader :member
  end
end
