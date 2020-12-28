module Google
  class EventMock
    class Creator
      attr_reader :email, :display_name

      def initialize(email:, display_name: "Pascal Fluffy")
        @email = email
        @display_name = display_name
      end
    end

    class Time
      attr_reader :date_time, :timezone

      def initialize(date_time: DateTime.now, timezone: "utc")
        @date_time = date_time
        @timezone = timezone
      end
    end

    attr_reader :event_unifier

    def initialize(event_unifier:)
      @event_unifier = event_unifier
    end

    def organizer
      @_organizer ||= Creator.new(
        email_attr: event_unifier.organizable,
        display_name_attr: event_unifier.organizable
      )
    end

    def creator
      @_organizer ||= Creator.new(
        email: event_unifier.creatable,
        display_name: event_unifier.creatable
      )
    end

    def start
      @_start_time ||= Time.new(
        date_time: event_unifier.start_time
      )
    end

    def end
      @_start_time ||= Time.new(
        date_time: event_unifier.start_time + event_unifier.duration_minutes
      )
    end

    def etag
      SecureRandom.uuid
    end

    def id
      SecureRandom.uuid
    end

    def updated
      DateTime.now - 1.hour
    end

    def sequence
      (1..5).to_a.sample
    end

    def summary
      event_unifier.event_name
    end

    def description
      event_unifier.summary
    end

    def html_link
      "#"
    end

    def i_cal_uid
      SecureRandom.uuid
    end

    def attendees
      []
    end
  end
end
