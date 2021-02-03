module ExternalResources::Google::Events
  class Get < ::ExternalResources::Google::Calendars::Base
    def initialize(calendar_event:, session_info:)
      @calendar_event = calendar_event
      @session_info = session_info
    end

    def get
      connection.get_event(calendar_id, calendar_event.external_id)
    end

    private

    attr_reader :session_info, :calendar_event

    def calendar_id
      calendar_event.calendar.external_id
    end
  end
end
