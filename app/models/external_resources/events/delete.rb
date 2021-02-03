module ExternalResources::Events
  class Delete
    ADAPTORS = {
      google_oauth2: ExternalResources::Google::Events::Delete
    }

    def self.for(calendar_event)
      new(calendar_event: calendar_event).delete
    end

    def initialize(calendar_event:)
      @calendar_event = calendar_event
    end

    def delete
      adaptor.delete
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
