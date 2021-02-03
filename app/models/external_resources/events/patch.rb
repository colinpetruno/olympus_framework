module ExternalResources::Events
  class Patch < ::ExternalResources::Google::Calendars::Base
    ADAPTORS = {
      google_oauth2: ExternalResources::Google::Events::Patch
    }

    def self.update_booking(calendar_event:, booking:)
      new(calendar_event: calendar_event, booking: booking).patch
    end

    def initialize(calendar_event:, booking: nil)
      @booking = booking
      @calendar_event = calendar_event
    end

    def patch
      adaptor.patch
    end

    private

    attr_reader :booking, :calendar_event

    def adaptor
      @_adaptor ||= ADAPTORS[calendar_event.calendar.provider.to_sym].new(
        calendar_event: calendar_event,
        session_info: session_info,
        booking: booking
      )
    end

    def session_info
      @_session_info ||= ::Members::SessionInfo.for(
        calendar_event.profile.member
      )
    end
  end
end
