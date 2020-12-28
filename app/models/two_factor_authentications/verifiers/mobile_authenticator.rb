module TwoFactorAuthentications
  module Verifiers
    class MobileAuthenticator
      def self.verify(member, params)
        new(member, params).verify
      end

      def initialize(member, params)
        @member = member
        @params = params
      end

      def verify
        if totp.verify(otp, drift_behind: 15, at: DateTime.now.utc, after: last_used)
          auth_log = TwoFactorAuthLog.create!(
            authenticatable: mobile_auth_info,
            authed_on: DateTime.now,
            auth_status: :succeeded,
            member: member
          )

          mobile_auth_info.update(last_otp_used_at: DateTime.now.utc)
        else
          auth_log = TwoFactorAuthLog.create!(
            authenticatable: mobile_auth_info,
            authed_on: DateTime.now,
            auth_status: :failed,
            member: member
          )
        end

        return auth_log
      end

      private

      attr_reader :member, :params

      def last_used
        # default it to awhile ago if not used yet
        mobile_auth_info.last_otp_used_at || (DateTime.now - 1.hour)
      end

      def mobile_auth_info
        @_mobile_auth_info ||= TwoFactorAuthentications::Finder.
          for(member).
          mobile_authenticator
      end

      def otp_base
        mobile_auth_info.otp_base
      end

      def totp
        @_totp ||= ROTP::TOTP.new(otp_base)
      end

      def otp
        params[:otp_password]
      end
    end
  end
end
