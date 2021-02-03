module ExternalResources::Google::Calendars
  class AddEvent < ::ExternalResources::Google::Calendars::Base
    def self.for(booking:, calendar:)
      new(booking: booking, calendar: calendar).add
    end

    def initialize(calendar:, booking:)
      @booking = booking
      @calendar = calendar
    end

    def add
      created_event = connection.insert_event(
        calendar.external_id,
        google_event,
        conference_data_version: nil,
        max_attendees: nil,
        send_notifications: nil,
        send_updates: nil,
        supports_attachments: nil,
        fields: nil,
        quota_user: nil,
        user_ip: nil,
        options: nil
      )

      BookingExternalId.create(
        booking: booking,
        external_id: created_event.id,
        provider: :google_oauth2
      )

      created_event
    rescue Google::Apis::ClientError => error
    end

    private

    attr_reader :booking, :calendar

    def google_event
      Google::Apis::CalendarV3::Event.new(
        anyone_can_add_self: false,
#        attachments: [],
        attendees: attendees,
#        attendees_omitted: nil,
#        color_id: nil,
#        conference_data: nil,
#        created: nil,
        creator: {
          email: booking.email
        },
        description: booking.details,
        end: {
          date_time: booking_end_time.rfc3339,
          time_zone: calendar.timezone
        },
        end_time_unspecified: false,
        # etag: nil,
#        extended_properties: nil,
#        gadget: nil,
        guests_can_invite_others: false,
        guests_can_modify: false,
        guests_can_see_other_guests: true,
#        hangout_link: nil,
        # html_link: nil, readonly property
#        i_cal_uid: nil,
#        id: nil,
        kind: "calendar#event",
#        location: nil,
        locked: false,
        # organizer: nil,
#        original_start_time: nil,
#        private_copy: nil,
#        recurrence: nil,
#        recurring_event_id: nil,
#        reminders: nil,
#        sequence: nil,
        source: {
          title: "Meettrics",
          url: "https://www.meettrics.com"
        },
        start: {
          date_time: booking.start_time.rfc3339,
          time_zone: calendar.timezone
        },
        status: "confirmed", # 'tentative', 'cancelled'
        summary: event_title, # this is the event title
        transparency: "opaque", # 'transparent' determines if event blocks other events
#        updated: nil,
        visibility: "default" # 'public', 'private', 'confidential'
      )
    end

    def attendees
      attendee_list = []

      # add the organizer (the person booking the meeting)
      attendee_list.push({
        additional_guests: 0,
        display_name: booking.name,
        email: booking.email,
        id: nil,
        optional: false,
        organizer: true,
        response_status: "accepted"
      })

      # add the booked attendent
      attendee_list.push({
        additional_guests: 0,
        display_name: session_info.profile.full_name,
        email: session_info.profile.email,
        id: nil,
        optional: false,
        organizer: false,
        response_status: "accepted" # 'needsAction', 'declined', 'tentative'
      })

      # add guests for the booking
      booking.guest_array.each do |guest|
        attendee_list.push({
          additional_guests: 0,
          display_name: guest,
          email: guest,
          id: nil,
          optional: false,
          organizer: false,
          response_status: "needsAction" # 'needsAction', 'declined', 'tentative'
        })
      end

      attendee_list
    end

    def event_title
      "#{session_info.profile.full_name} <> #{booking.name}"
    end

    def booking_end_time
      booking.start_time + booking.duration_minutes.minutes
    end

    def session_info
      @_session_info ||= Members::SessionInfo.for(calendar.profile.member)
    end
  end
end


# def insert_event(
# calendar_id,
# event_object = nil, https://developers.google.com/calendar/v3/reference/events#resource
# conference_data_version: nil,
# max_attendees: nil,
# send_notifications: nil,
# send_updates: nil,
# supports_attachments: nil,
# fields: nil,
# quota_user: nil,
# user_ip: nil,
# options: nil,
# &block)
