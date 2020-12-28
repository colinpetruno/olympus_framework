class GdprExporter
  include ::Harpocrates::Exporter

  def self.for(profile)
    new(profile)
  end

  def initialize(profile)
    @profile = profile
  end

  def structure
    {
      profile: profile,
      company: company,
      billing_sources: ::Billing::Source.where(created_by_id: profile.id),
      calendar_events: calendar_events,
      calendar_event_details: calendar_events.map(&:calendar_event_detail),
      calendars: Calendar.where(profile_id: profile.id),
      contact_us: ContactUsRequest.where(profile_id: profile.id),
      meeting_templates: meeting_templates,
      meeting_availabilities: meeting_templates.
        map(&:meeting_availabilities).
        flatten,
      blocked_calendars: meeting_templates.
        map(&:meeting_template_blocked_calendars).
        flatten,
      meeting_template_meeting_rooms: meeting_templates.
        map(&:meeting_template_meeting_rooms).
        flatten,
      meeting_template_synced_calendars: meeting_templates.
        map(&:meeting_template_synced_calendars),
      schedule_settings: ScheduleSetting.where(profile_id: profile.id),
      team: profile.team
    }
  end

  private

  attr_reader :profile

  def meeting_templates
    @_meeting_templates ||= MeetingTemplate.
      where(profile_id: profile.id).
      includes(
        :meeting_availabilities,
        :meeting_template_blocked_calendars,
        :meeting_template_meeting_rooms,
        :meeting_template_synced_calendars
      )
  end

  def calendar_events
    @_calendar_events ||= CalendarEvent.where(profile_id: profile.id).
      includes(:calendar_event_detail)
  end

  def member
    @_member ||= profile.member
  end

  def company
    @_company ||= profile.company
  end
end
