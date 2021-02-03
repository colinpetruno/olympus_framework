module ExternalResources::Events
  class Get
    ADAPTORS = {
      google_oauth2: ExternalResources::Google::Events::Get
    }

    def self.for(calendar_event)
      new(calendar_event: calendar_event).get
    end

    def initialize(calendar_event:)
      @calendar_event = calendar_event
    end

    def get
      adaptor.get
    end

    private

    attr_reader :calendar_event

    private

    def adaptor
      @_adaptor ||= ADAPTORS[calendar_event.calendar.provider.to_sym].new(
        calendar_event: calendar_event,
        session_info: session_info
      )
    end

    def session_info
      @_session_info ||= ::Members::SessionInfo.for(
        calendar_event.profile.member
      )
    end
  end
end
