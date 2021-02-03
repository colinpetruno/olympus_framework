module ExternalResources::Google::Events
  class Delete < ::ExternalResources::Google::Calendars::Base
    def initialize(calendar_event:, session_info:)
      @calendar_event = calendar_event
      @session_info = session_info
    end

    def delete
      connection.delete_event(
        calendar_id,
        calendar_event.external_id,
        send_updates: "all"
      )
    end

    private

    attr_reader :session_info, :calendar_event

    def calendar_id
      calendar_event.calendar.external_id
    end
  end
end
