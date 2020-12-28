module Admin::Support::Members
  class ShowPresenter
    attr_reader :member

    def self.for(member)
      new(member)
    end

    def initialize(member)
      @member = member
    end

    def full_name
      member.profile.full_name
    end

    def company
      member.profile.company
    end

    def company_name
      member.profile.company.name
    end

    def member_auth_type
      member.provider
    end

    def current_sign_in
      [member.current_sign_in_ip, member.current_sign_in_at].join(" - ")
    end

    def last_sign_in
      [member.last_sign_in_ip, member.last_sign_in_at].join(" - ")
    end

    def sign_in_count
      member.sign_in_count
    end

    def page_views
      @_page_views ||= ::Members::PageViewsFinder.for(@member).recent
    end
  end
end
