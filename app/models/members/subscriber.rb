module Members
  class Subscriber
    def self.for(member)
      new(member).subscribe
    end

    def initialize(member)
      @member = member
    end

    def subscribe
      UnsubscribeLog.create!(
        profile: member.profile,
        action: :subscribe,
        acted_on: DateTime.now
      )

      ::ExternalResources::Sendgrid::GlobalUnsubscribes.new.remove_email(
        member.profile.email
      )
    end

    private

    attr_reader :member
  end
end
