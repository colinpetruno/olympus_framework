module Members
  class PageViewsFinder
    def self.for(member)
      new(member)
    end

    def initialize(member)
      @member = member
    end

    def recent(count=10)
      ::Ichnaea::PageView.
        where(viewed_by_id: ichnaea_user_ids).
        order(viewed_at: :desc).
        limit(count).
        includes(:url, :user_agent)
    end

    private

    attr_reader :member

    def ichnaea_user_ids
      # CHANGE: from singular to plural if using multiple companies per user

      profiles = [member.profile]

      @_ichnaea_user_ids ||= ::Ichnaea::User.
        where(userable: profiles).
        pluck(:id)
    end
  end
end
