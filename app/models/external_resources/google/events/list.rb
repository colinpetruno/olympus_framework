module ExternalResources::Google::Events
  class List < ::ExternalResources::Google::Calendars::Base
    attr_accessor :events, :page_number, :next_sync_token

    def initialize(session_info:, calendar:)
      super(session_info: session_info)
      @calendar = calendar
      @events = []
      @page_number = 0
    end

    def next_page?
      if page_number == 0
        true
      else
        response.next_page_token.present?
      end
    end

    def list_next_page
      if next_page?
        # set the current page to the next one
        current_page = get_next_page

        # list the items
        events = current_page.items

        # if this is the last page set the next sync token to be used later
        if current_page.next_sync_token.present?
          self.next_sync_token = current_page.next_sync_token
        end

        self.page_token = response.next_page_token
        self.page_number = page_number + 1
      else
        events = []
      end

      events
    end

    private

    attr_reader :calendar
    attr_accessor :current_page, :response, :page_token

    def get_next_page
      @response ||= list_events
    rescue Google::Apis::ClientError
      Rails.logger.info("Sync token is invalid so forcing full sync")
      @_force_full_sync = true

      # TODO: We could tighten up the retry system here. For now I only want
      # to catch when the sync token is invalid and resync it again without
      # the sync token.
      @response ||= list_events
    end

    def list_events
      connection.list_events(
        calendar.external_id,
        always_include_email: true,
        i_cal_uid: nil,
        fields: nil,
        max_attendees: nil,
        max_results: max_results,
        order_by: order_by,
        options: nil,
        page_token: page_token,
        private_extended_property: nil,
        q: nil,
        quota_user: nil,
        shared_extended_property: nil,
        show_deleted: true,
        show_hidden_invitations: show_hidden_invitations,
        single_events: single_events,
        sync_token: sync_token,
        time_max: time_max,
        time_min: time_min,
        time_zone: time_zone,
        updated_min: nil,
        user_ip: nil,
      )
    end

    def time_max
      nil
    end

    def time_min
      # dates need to be in this format RFC3339
      # 2011-06-03T10:00:00-07:00
      # DateTime.now.rfc3339
      nil
    end

    def time_zone
      nil
    end

    def show_deleted
      true
    end

    def force_full_sync?
      @_force_full_sync ||= false
    end

    def sync_token
      if force_full_sync?
        nil
      else
        calendar.next_event_sync_token
      end
    end

    def single_events
      # expand recurring events into instances and only return single one-off
      # events and instances of recurring events, but not the underlying
      # recurring events themselves. Optional. The default is False.
    end

    def show_hidden_invitations
      true
    end

    def order_by
      # "startTime" or "updated"
      nil
    end

    def max_results
      1000
    end
  end
end

## item.created DateTime
## item.creator
## item.creator.email String
## item.creator.self Boolean
## item.end
## item.end.date_time DateTime
## item.etag String
## item.html_link String
## item.i_cal_uid String
## item.id String
## item.kind String calendar#event
## item.organizer
## item.organizer.email String
## item.organizer.self Boolean
## item.reminders
## item.reminders.use_default Boolean
## item.sequence
## item.start
## item.start.date_time
## item.status String "confirmed"
## item.summary String
## item.updated DateTime
#
#
# sequence is interesting because it should be a revision number, however things
# like description updates may trigger it and the list of events in the spec
# are not finite but rather open ended and up for intrepretation
#
#
#
# full result properties
# @access_role="owner",
# @default_reminders=[#<Google::Apis::CalendarV3::EventReminder:0x00007fee88a5f3d8 @minutes=10, @reminder_method="popup">],
# @etag="\"p33ca1rc6getee0g\"",
#  @items=
# @kind="calendar#events",
# @next_sync_token="CNig7YaDuucCENig7YaDuucCGAU=",
# @summary="colin@meettrics.com",
# @time_zone="Europe/Amsterdam",
# @updated=Wed, 05 Feb 2020 08:46:21 +0000
# @etag
# @default_reminders
#
#
#
#
#
#
#
#
#
#
#
#
# TEST EVENT ONE PRE CHANGE
# [#<Google::Apis::CalendarV3::Event:0x00007fee88a5e708
#    @created=Tue, 04 Feb 2020 19:22:45 +0000,
#    @creator=#<Google::Apis::CalendarV3::Event::Creator:0x00007fee88a5d218 @email="colin@meettrics.com", @self=true>,
#    @end=#<Google::Apis::CalendarV3::EventDateTime:0x00007fee88a5c598 @date_time=Thu, 06 Feb 2020 09:00:00 +0100>,
#    @etag="\"3161688331014000\"",
#    @html_link="https://www.google.com/calendar/event?eid=MGI5cG01cTdpbzlxbG50bGdpaW8wcjVpdTYgY29saW5AbWVldHRyaWNzLmNvbQ",
#    @i_cal_uid="0b9pm5q7io9qlntlgiio0r5iu6@google.com",
#    @id="0b9pm5q7io9qlntlgiio0r5iu6",
#    @kind="calendar#event",
#    @organizer=#<Google::Apis::CalendarV3::Event::Organizer:0x00007fee88a6e068 @email="colin@meettrics.com", @self=true>,
#    @reminders=#<Google::Apis::CalendarV3::Event::Reminders:0x00007fee88a6cec0 @use_default=true>,
#    @sequence=0,
#    @start=#<Google::Apis::CalendarV3::EventDateTime:0x00007fee88a6c3f8 @date_time=Thu, 06 Feb 2020 08:00:00 +0100>,
#    @status="confirmed",
#    @summary="Test Event 1",
#    @updated=Tue, 04 Feb 2020 19:22:45 +0000>,
#
#
#
#
#
#
#    THIS IS A PRIVATE EVENT
#
#       #<Google::Apis::CalendarV3::Event:0x00007fee86393a38
#    @attendees=
#     [#<Google::Apis::CalendarV3::EventAttendee:0x00007fee86392ea8 @email="beaudine@meettrics.com", @response_status="needsAction">,
      #<Google::Apis::CalendarV3::EventAttendee:0x00007fee863902e8 @email="colin@meettrics.com", @organizer=true, @response_status="accepted", @self=true>],
#    @created=Wed, 05 Feb 2020 12:47:32 +0000,
#    @creator=#<Google::Apis::CalendarV3::Event::Creator:0x00007fee863a9f68 @email="colin@meettrics.com", @self=true>,
#    @description="this is a test private event",
#    @end=#<Google::Apis::CalendarV3::EventDateTime:0x00007fee863a9158 @date_time=Thu, 06 Feb 2020 12:15:00 +0100>,
#    @etag="\"3161813704644000\"",
#    @html_link="https://www.google.com/calendar/event?eid=Nmp1N3M1dTBha29rMGN0cHJ1bXUxaXZtMWQgY29saW5AbWVldHRyaWNzLmNvbQ",
#    @i_cal_uid="6ju7s5u0akok0ctprumu1ivm1d@google.com",
#    @id="6ju7s5u0akok0ctprumu1ivm1d",
#    @kind="calendar#event",
#    @organizer=#<Google::Apis::CalendarV3::Event::Organizer:0x00007fee8ed7a878 @email="colin@meettrics.com", @self=true>,
#    @reminders=#<Google::Apis::CalendarV3::Event::Reminders:0x00007fee8ed79540 @use_default=true>,
#    @sequence=0,
#    @start=#<Google::Apis::CalendarV3::EventDateTime:0x00007fee8ed788c0 @date_time=Thu, 06 Feb 2020 11:15:00 +0100>,
#    @status="confirmed",
#    @summary="Private event",
#    @updated=Wed, 05 Feb 2020 12:47:32 +0000,
#    @visibility="private">,
#
#
# def list_events(
      # calendar_id,
      # always_include_email: nil,
      # i_cal_uid: nil,
      # max_attendees: nil,
      # max_results: nil,
      # order_by: nil,
      # page_token: nil,
      # private_extended_property: nil,
      # q: nil,
      # shared_extended_property: nil,
      # show_deleted: nil,
      # show_hidden_invitations: nil,
      # single_events: nil,
      # sync_token: nil,
      # time_max: nil,
      # time_min: nil,
      # time_zone: nil,
      # updated_min: nil,
      # fields: nil,
      # quota_user: nil,
      # user_ip: nil,
      # options: nil,
      # &block
      # )
# )




# THIS IS an "OUT OF OFFICE EVENT"
   #<Google::Apis::CalendarV3::Event:0x00007fee8642ec68
#    @created=Sat, 08 Feb 2020 10:18:18 +0000,
#    @creator=#<Google::Apis::CalendarV3::Event::Creator:0x00007fee8642d408 @email="colin@meettrics.com", @self=true>,
#    @description="This is an out-of-office event, which can only be edited in Google Calendar. Meetings during this time will be automatically declined.",
#    @end=#<Google::Apis::CalendarV3::EventDateTime:0x00007fee8642c760 @date_time=Mon, 10 Feb 2020 15:00:00 +0100>,
#    @etag="\"3162314196912000\"",
#    @html_link="https://www.google.com/calendar/event?eid=MDY1OTBsYzZ1YTBycmdwM2FpbGtncWM2bTAgY29saW5AbWVldHRyaWNzLmNvbQ",
#    @i_cal_uid="06590lc6ua0rrgp3ailkgqc6m0@google.com",
#    @id="06590lc6ua0rrgp3ailkgqc6m0",
#    @kind="calendar#event",
#    @organizer=#<Google::Apis::CalendarV3::Event::Organizer:0x00007fee86435c98 @email="colin@meettrics.com", @self=true>,
#    @reminders=#<Google::Apis::CalendarV3::Event::Reminders:0x00007fee864348c0 @use_default=false>,
#    @sequence=0,
#    @start=#<Google::Apis::CalendarV3::EventDateTime:0x00007fee8643fab8 @date_time=Mon, 10 Feb 2020 14:00:00 +0100>,
#    @status="confirmed",
#    @summary="Out of office",
#    @updated=Sat, 08 Feb 2020 10:18:18 +0000,
#    @visibility="public">],
      #
      #
      #


##### THIS IS A RECURRING EVENT
#   #<Google::Apis::CalendarV3::Event:0x00007fee86405ed0
#    @attendees=
#     [#<Google::Apis::CalendarV3::EventAttendee:0x00007fee86405610 @display_name="New demo calendar", @email="meettrics.com_6l17c4c8sgr5oj5k3ic430t2t0@group.calendar.google.com", @response_status="needsAction">,
#      #<Google::Apis::CalendarV3::EventAttendee:0x00007fee8640fea8 @email="colin@meettrics.com", @organizer=true, @response_status="accepted", @self=true>,
#      #<Google::Apis::CalendarV3::EventAttendee:0x00007fee8640e6e8 @email="beaudine@meettrics.com", @response_status="needsAction">],
#    @conference_data=
#     #<Google::Apis::CalendarV3::ConferenceData:0x00007fee8640cd70
#      @conference_id="uux-escp-gjq",
#      @conference_solution=
#       #<Google::Apis::CalendarV3::ConferenceSolution:0x00007fee8640c708
#        @icon_uri="https://lh5.googleusercontent.com/proxy/bWvYBOb7O03a7HK5iKNEAPoUNPEXH1CHZjuOkiqxHx8OtyVn9sZ6Ktl8hfqBNQUUbCDg6T2unnsHx7RSkCyhrKgHcdoosAW8POQJm_ZEvZU9ZfAE7mZIBGr_tDlF8Z_rSzXcjTffVXg3M46v",
#        @key=#<Google::Apis::CalendarV3::ConferenceSolutionKey:0x00007fee8640c0f0 @type="hangoutsMeet">,
#        @name="Hangouts Meet">,
#      @entry_points=
#       [#<Google::Apis::CalendarV3::EntryPoint:0x00007fee86417388 @entry_point_type="video", @label="meet.google.com/uux-escp-gjq", @uri="https://meet.google.com/uux-escp-gjq">,
#        #<Google::Apis::CalendarV3::EntryPoint:0x00007fee86415e98 @entry_point_type="more", @pin="1367198316903", @uri="https://tel.meet/uux-escp-gjq?pin=1367198316903">,
#        #<Google::Apis::CalendarV3::EntryPoint:0x00007fee864147a0 @entry_point_type="phone", @label="+31 20 257 6805", @pin="376559633", @region_code="NL", @uri="tel:+31-20-257-6805">],
#      @signature="AKipslUoELebA/95gf2e3abL9X1S">,
#    @created=Sat, 08 Feb 2020 10:17:55 +0000,
#    @creator=#<Google::Apis::CalendarV3::Event::Creator:0x00007fee8641e390 @email="colin@meettrics.com", @self=true>,
#    @end=#<Google::Apis::CalendarV3::EventDateTime:0x00007fee8641d6e8 @date_time=Mon, 10 Feb 2020 13:00:00 +0100, @time_zone="Europe/Amsterdam">,
#    @etag="\"3162314151116000\"",
#    @hangout_link="https://meet.google.com/uux-escp-gjq",
#    @html_link="https://www.google.com/calendar/event?eid=MzVxNDM4NjhrdjRsMWJsdDJmamIzYWEyZXFfMjAyMDAyMTBUMTEwMDAwWiBjb2xpbkBtZWV0dHJpY3MuY29t",
#    @i_cal_uid="35q43868kv4l1blt2fjb3aa2eq@google.com",
#    @id="35q43868kv4l1blt2fjb3aa2eq",
#    @kind="calendar#event",
#    @organizer=#<Google::Apis::CalendarV3::Event::Organizer:0x00007fee86426bd0 @email="colin@meettrics.com", @self=true>,
#    @recurrence=["RRULE:FREQ=WEEKLY;BYDAY=MO"],
#    @reminders=#<Google::Apis::CalendarV3::Event::Reminders:0x00007fee86425668 @use_default=true>,
#    @sequence=0,
#    @start=#<Google::Apis::CalendarV3::EventDateTime:0x00007fee86424a38 @date_time=Mon, 10 Feb 2020 12:00:00 +0100, @time_zone="Europe/Amsterdam">,
#    @status="confirmed",
#    @summary="Lunch",
#    @updated=Sat, 08 Feb 2020 10:17:55 +0000>,
      #
      #
      #
      #
      #
#      #    	List of RRULE, EXRULE, RDATE and EXDATE lines for a recurring event, as specified in RFC5545. Note that DTSTART and DTEND lines are not allowed in this field; event start and end times are specified in the start and end fields. This field is omitted for single events or instances of recurring events.
#      #
#      #
#      #
#      #    https://tools.ietf.org/html/rfc5545#section-3.8.5
      #
