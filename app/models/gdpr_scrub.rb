class GdprScrub
  include Harpocrates::Scrubber

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
      beta_request: beta_request,
      contact_us: ContactUsRequest.where(profile_id: profile.id),
      billing_detail: billing_detail,
      downgrades: ::Billing::Downgrade.where(company: company),
      billing_sources: ::Billing::Source.where(created_by_id: profile.id),
      calendar_events: calendar_events,
      calendar_event_details: calendar_events.map(&:calendar_event_detail),
      calendars: Calendar.where(profile_id: profile.id),
      meeting_templates: meeting_templates,
      member: profile.member
    }
  end

  private

  attr_reader :profile

  def meeting_templates
    @_meeting_templates ||= MeetingTemplate.
      where(profile_id: profile.id).
      includes(:meeting_availabilities)
  end

  def calendar_events
    @_calendar_events ||= CalendarEvent.where(profile_id: profile.id).
      includes(:calendar_event_detail)
  end

  def beta_request
    # unique since not associated
    BetaRequest.find_by(hashed_email: ::Portunus::Hasher.for(profile.email))
  end

  def member
    @_member ||= profile.member
  end

  def company
    @_company ||= profile.company
  end
end
