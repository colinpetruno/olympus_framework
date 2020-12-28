module Members
  class Unsubscriber
    def self.for(member)
      new(member).unsubscribe
    end

    def initialize(member)
      @member = member
      @profile = member.profile
    end

    def unsubscribe
      notification_preference.update(
        marketing_emails: false,
        unsubscribed: true
      )

      UnsubscribeLog.create!(
        profile: profile,
        action: :unsubscribe,
        acted_on: DateTime.now
      )

      # sync to all external places, right now it's just sendgrid
      ::ExternalResources::Sendgrid::GlobalUnsubscribes.new.add_emails(
        [profile.email]
      )

      return true
    rescue StandardError => error
      Errors::Reporter.notify(error)

      return false
    end

    private

    attr_reader :member, :profile

    def notification_preference
      @_notification_preference ||= Profiles::NotificationPreference.for(
        profile
      )
    end
  end
end
