class BookingCreatedJob < ApplicationJob
  queue_as :bookings

  attr_reader :booking

  def perform(booking_id)
    @booking = Booking.find(booking_id)

    # This will sync to the right calendars specified in the meeting template
    # When we add a guest to someones calendar the guest will get an email as
    # well. However since we can't rely on the person having their
    # configurations correct, we should also send the email to the person
    # who created the booking as well.
    meeting_template.synced_calendars.each do |calendar|
      ExternalResources::Calendars::AddEvent.for(
        booking: booking,
        calendar: calendar
      )

      ::Syncs::Queuer.new(
        ::Members::SessionInfo.for(calendar.profile.member)
      ).queue(
        "Syncs::CalendarEventsSync",
        calendar
      )
    end
  end

  private

  def meeting_template
    @_meeting_template ||= booking.meeting_template
  end
end

