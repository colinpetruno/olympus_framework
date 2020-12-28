module Scheduling
  class CancelBookingJob < ApplicationJob
    queue_as :bookings

    attr_reader :booking

    def perform(booking_id)
      # NOTE: We take a booking here so we can always pull the last
      # resschedule. If we took a reschedule, if they do two reschedules fast
      # or something goes wrong the job could get messed up
      @booking = Booking.find(booking_id)

      external_ids.map do |external_id|
        calendar_event = ::CalendarEvent.find_by!(
          external_id: external_id.external_id
        )

        # bookings can be synced to many calendars, thus for a cancellation we
        # need to map each external id and then find the calendar event for that
        ExternalResources::Events::Delete.for(calendar_event)
      end
    end

    def external_ids
      @booking.booking_external_ids
    end

    def reschedule
      booking.reschedules.order(:created_at).last
    end
  end
end
