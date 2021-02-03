module ExternalResources::Google::Calendars
  class List < ::ExternalResources::Google::Calendars::Base
    def get_all
      if !loaded?
        load_calendars
      end

      item_list
    end

    def reload!
      @item_list = []
      load_calendars
      item_list
    end

    private

    def load_calendars
      page_token = nil
      begin
        result = connection.
          list_calendar_lists(
            page_token: page_token,
            show_deleted: false,
            show_hidden: true
          )

        @item_list = item_list + result.items

        if result.next_page_token != page_token
          page_token = result.next_page_token
        else
          page_token = nil
        end
      end while !page_token.nil?
    end

    def item_list
      @item_list ||= []
    end

    def loaded?
      @loaded ||= false
    end
  end
end


#### Examples
# https://developers.google.com/calendar/quickstart/ruby
# List all calendar events
# now = Time.now.iso8601
# items = calendar.fetch_all do |token|
#   calendar.list_events('primary',
#                         single_events: true,
#                         order_by: 'startTime',
#                         time_min: now,
#                         page_token: token)
# end
# items.each { |event| puts event.summary }
#
#
# Google::Apis::CalendarV3::CalendarListEntry
# access_role, access_role=,
# background_color, background_color=,
# color_id, color_id=,
# conference_properties, conference_properties=,
# default_reminders, default_reminders=,
# deleted, deleted=, deleted?,
# description, description=,
# etag, etag=,
# foreground_color, foreground_color=, freeze, frozen?, gem, hash,
# hidden, hidden=, hidden?,
# id, id=,  #THIS is the id of the calendar
# kind, kind=, kind_of?,
# location, location=,
# notification_settings, notification_settings=, Google::Apis::CalendarV3::CalendarNotification
# object_id,
# primary, primary=, primary?,
# selected, selected=, selected?,
# summary, summary=,
# summary_override, summary_override=,
# time_zone, time_zone=,
# update!"
