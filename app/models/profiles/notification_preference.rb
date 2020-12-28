module Profiles
  class NotificationPreference
    def self.for(profile)
      new(profile).find
    end

    def initialize(profile)
      @profile = profile
    end

    def find
      profile.notification_preference || create_preference
    end

    private

    attr_reader :profile

    def create_preference
      profile.create_notification_preference(
        marketing_emails: false,
        unsubscribed: false
      )
    end
  end
end
