module TwoFactorAuthentications
  class Status
    def self.for(member, session)
      new(member: member, session: session)
    end

    def initialize(member:, session:)
      @member = member
      @session = session
    end

    def status
      return :not_required if !required?

      if authed_within?(last_inactivity: 30.minutes)
        :authed
      else
        :reauth
      end
    end

    def needs_authed?
      [:reauth].include?(status.to_sym)
    end

    private

    attr_reader :member, :session

    def required?
      TwoFactorAuthentications::Required.for?(member)
    end

    def authed_within?(last_inactivity:)
      (current_time - last_inactivity.to_i) < last_activity_time
    end

    def current_time
      DateTime.now.utc.to_i
    end

    def last_activity_time
      session[:two_factor_last_activity].to_i
    end
  end
end
