module CalendarCreatorHelper
  def create_calendar_for(member, count: 1, options: {})
    default_options = {
      profile_id: member.profile.id,
      company_id: member.company.id,
      event_count: 1,
      external_id: SecureRandom.uuid,
      provider: "google_oauth2",
      timezone: "Eastern Time (US & Canada)",
      etag: SecureRandom.uuid,
      primary: false,
      sync_enabled: true,
      last_metadata_sync: nil,
      last_event_sync: nil,
      deleted_at: nil,
      name: I18n.t("models.defaults.calendar.name")
    }

    calendars = []

    (1..count).map do |i|
      # a bit weird to have a double merge here but I want to ensure that the
      # calendar external id is unique per calendar and company to prevent
      # collisions

      adjusted_options = default_options.
        merge(options).
        merge(external_id: SecureRandom.uuid)

      # make primary if it's the first calendar they have
      adjusted_options.merge!(primary: true) if i == 1

      calendar = Calendar.create(adjusted_options.except(
        :event_count
      ))

      (0..(adjusted_options[:event_count] - 1)).each do
        # make events
        create_event_for(calendar)
      end

      calendars.push(calendar)
    end

    calendars
  end
end
