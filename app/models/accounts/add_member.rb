module Accounts
  class AddMember
    def self.add(member_attributes)
      new(member_attributes).add
    end

    def initialize(member_attributes)
      @member_attributes = member_attributes
    end

    def add
      # NOTE: You can expand any default seeding of member data here once
      # the member is created, or add tracking etc.
      Member.create!(member_attributes)
    end

    private

    attr_reader :member_attributes
  end
end
