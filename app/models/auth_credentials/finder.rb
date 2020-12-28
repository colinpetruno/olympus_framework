module AuthCredentials
  class Finder
    def self.for(session_info)
      new(session_info).find
    end

    def initialize(session_info)
      @session_info = session_info
    end

    def find_by_calendar(calendar)
      find.find_by(provider: calendar.provider)
    end

    def find
      credentials = AuthCredential.where(member_id: session_info.member.id)

      if credentials.blank?
      end

      credentials
    end

    def find_with_statuses
      AuthCredentials::Statuses.for(session_info, find)
    end

    private

    attr_reader :session_info
  end
end
