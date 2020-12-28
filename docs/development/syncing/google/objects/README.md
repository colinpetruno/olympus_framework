# Google Objects

This guide contains reference and notes of the google objects and their 
various abilities.

### Google::Apis::CalendarV3::CalendarListEntry

##### Methods
- access_role, access_role=,
- background_color, background_color=,
- color_id, color_id=,
- conference_properties, conference_properties=,
- default_reminders, default_reminders=,
- deleted, deleted=, deleted?,
- description, description=,
- etag, etag=,
- foreground_color, foreground_color=, freeze, frozen?, gem, hash,
- hidden, hidden=, hidden?,
- id, id=,  #THIS is the id of the calendar
- kind, kind=, kind_of?,
- location, location=,
- notification_settings, notification_settings=, Google::Apis::CalendarV3::CalendarNotification
- object_id,
- primary, primary=, primary?,
- selected, selected=, selected? - this is if the calendar in the list is displayed, could be good proxy for enabled or not..
- summary, summary=,
- summary_override, summary_override=,
- time_zone, time_zone=,
- update!"

##### Notes
- etag = will change when the resource changes, we should be able to use this
  to quickly compare and see if there are any changes present in the calendars
  list. 
