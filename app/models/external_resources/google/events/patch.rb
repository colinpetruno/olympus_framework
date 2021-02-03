module ExternalResources::Google::Events
  class Patch < ::ExternalResources::Google::Calendars::Base

    def initialize(calendar_event:, booking: nil, session_info: nil)
      @calendar_event = calendar_event
      @booking = booking
      @_session_info = session_info
    end

    def patch
      if booking.present?
        sync_from_booking
      else
        sync_from_event
      end

      connection.update_event(calendar_id, event.id, event)
    end

    private

    attr_reader :calendar_event, :booking

    def sync_from_booking
      event.start = {
        date_time: booking.current_start_time.rfc3339,
        time_zone: booking.current_timezone
      }

      event.end = {
        date_time: booking.current_end_time.rfc3339,
        time_zone: booking.current_timezone
      }
    end

    def sync_from_event
      event.start = {
        date_time: calendar_event.start_time.rfc3339,
        time_zone: calendar_event.calendar.timezone
      }

      event.end = {
        date_time: calendar_event.end_time.rfc3339,
        time_zone: calendar_event.calendar.timezone
      }
    end

    def event
      @_event ||= retrieve_event
    end

    def retrieve_event
      connection.get_event(calendar_id, calendar_event.external_id)
    end

    def calendar_id
      calendar_event.calendar.external_id
    end

    def session_info
      @_session_info ||= ::Members::SessionInfo.for(
        calendar_event.profile.member
      )
    end
  end
end


