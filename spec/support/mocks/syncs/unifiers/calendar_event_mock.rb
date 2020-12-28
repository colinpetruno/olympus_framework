module Syncs::Unifiers
  class CalendarEventMock
    def self.from_meettrics(calendar_event)
      new(
        creatable: calendar_event.creatable.email,
        duration_minutes: calendar_event.duration_minutes,
        end_time: calendar_event.end_time,
        organizable: calendar_event.organizable.email,
        participant_count: calendar_event.participant_count,
        start_time: calendar_event.start_time,
        event_name: calendar_event.calendar_event_detail.name,
        summary: calendar_event.calendar_event_detail.summary,
        object: calendar_event
      )
    end

    attr_accessor :creatable, :duration_minutes, :end_time, :organizable,
                  :participant_count, :start_time, :event_name, :summary,
                  :object

    def initialize(
      creatable:,
      duration_minutes:,
      end_time:,
      organizable:,
      participant_count:,
      start_time:,
      event_name:,
      summary:,
      object:
    )
      @creatable = creatable
      @duration_minutes = duration_minutes
      @end_time = end_time
      @organizable = organizable
      @participant_count = participant_count
      @start_time = start_time
      @event_name = event_name
      @summary = summary
      @object = object
    end
  end
end
