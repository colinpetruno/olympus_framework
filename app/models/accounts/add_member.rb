module Accounts
  class AddMember
    def self.add(member_attributes)
      new(member_attributes).add
    end

    def initialize(member_attributes)
      @member_attributes = member_attributes
    end

    def add
      member = Member.create!(member_attributes)

      # create default templates for the user
      templates = MeetingTemplates::DefaultCreator.for(member.profile)
      ScheduleSettings::Creator.for(member.profile, templates)

      # TODO: Queue the calendar sync so it can be ready when they get there
      member
    end

    private

    attr_reader :member_attributes
  end
end
