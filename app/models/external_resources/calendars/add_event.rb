module ExternalResources::Calendars
  class AddEvent
    ADAPTORS = {
      google_oauth2: ::ExternalResources::Google::Calendars::AddEvent
    }
    def self.for(calendar:, booking:)
      new(calendar: calendar, booking: booking).add
    end

    def initialize(calendar:, booking:)
      @booking = booking
      @calendar = calendar
    end

    def add
      adaptor.add
    end

    private

    attr_reader :booking, :calendar

    def adaptor
      @_adaptor = ADAPTORS[calendar.provider.to_sym].new(
        booking: booking,
        calendar: calendar
      )
    end
  end
end
