module Bookings
  class CancelledJob < ApplicationJob
    queue_as :bookings

    attr_reader :booking

    def perform(booking_id)
      @booking = Booking.find(booking_id)
    end
  end
end
