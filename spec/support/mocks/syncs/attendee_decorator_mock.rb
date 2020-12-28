module Syncs
  class AttendeeDecoratorMock
    def self.from_event_participant(event_participant)
      new(
        email: event_participant.participatable.email,
        display_name:  event_participant.participatable.full_name,
        response_status: event_participant.response_status,
        optional: event_participant.optional?,
        organizer: event_participant.organizer?
      )
    end

    def initialize(properties={})
      @email = properties[:email]
      @display_name = properties[:display_name]
      @response_status = properties[:response_status]
      @optional = properties[:optional]
      @organizer = properties[:organizer]
    end

    def email
      @email || Faker::Internet.email
    end

    def display_name
      @display_name || Faker::Name.name
    end

    def response_status
      @response_status || EventParticipant.response_statuses.keys.sample
    end

    def optional?
      @optional || false
    end

    def organizer?
      @organizer || false
    end

    # unify with the rails api
    def optional
      @optional || false
    end

    def organizer
      @organizer || false
    end
  end
end
