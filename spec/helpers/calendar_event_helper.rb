module CalendarEventHelper
  def create_event_for(calendar)
    CalendarEvent.create({
      etag: SecureRandom.base36,
      profile_id: calendar.profile_id,
      creatable: calendar.profile,
      organizable: calendar.profile,
      last_revised_at: DateTime.now,
      participant_count: 1,
      internal_participants: 0,
      external_participants: 0,
      rescheduled_count: 1,
      duration_minutes: 30,
      most_recent: true,
      company_id: calendar.company_id,
      start_time: DateTime.now,
      end_time: DateTime.now,
      calendar_id: calendar.id,
      external_id: SecureRandom.uuid,
      calendar_event_detail_attributes: {
        name: "Demo event name",
        summary: "this is the description",
        html_link: "#",
        ical_uid: "#"
      },
      event_participants_attributes: [
        {
          participatable: calendar.profile,
          response_status: :accepted,
          optional: false,
          organizer: true,
          company_id: calendar.company_id
        }
      ]
    })
  end
end
