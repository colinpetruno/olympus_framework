module Authentication
  class MobileAuthenticatorsController < AuthenticatedController
    def update
      @mobile_authenticator = TwoFactorAuthentications::Finder.
        for(current_member).
        mobile_authenticator

      totp = ROTP::TOTP.new(@mobile_authenticator.otp_base)

      verified_timestamp = totp.verify(
        mobile_authenticator_params[:otp_password],
        drift_behind: 15,
        at: DateTime.now
      )

      if verified_timestamp.present?
        if @mobile_authenticator.enabled?
          disable_mobile_auth(@mobile_authenticator)
        else
          enable_mobile_auth(@mobile_authenticator)

          # Set this so they won't be force to reauth right away after the
          # creation of the 2FA.
          session[:two_factor_authed_at] = DateTime.now.utc.to_i
          session[:two_factor_last_activity] = DateTime.now.utc.to_i
        end

        if session[:after_enrollment_path].present?
          enrollment_path = session[:after_enrollment_path].dup
          session[:after_enrollment_path] = nil # clean up the session

          redirect_to(
            enrollment_path,
            flash: { success: "Mobile authenticator settings applied" }
          )
        else
          redirect_to(
            new_auth_two_factor_authentication_path,
            flash: { success: "Mobile authenticator settings applied" }
          )
        end
      else
        redirect_to(
          new_auth_two_factor_authentication_path,
          flash: { error: "Incorrect password code" }
        )
      end
    end

    private

    def enable_mobile_auth(mobile_authenticator)
      ApplicationRecord.transaction do
        mobile_authenticator.update(enabled: true)
        mobile_authenticator.two_factor_authentication.update(enabled: true)
      end
    end

    def disable_mobile_auth(mobile_authenticator)
      ApplicationRecord.transaction do
        mobile_authenticator.update(enabled: false, deleted_at: DateTime.now)
        mobile_authenticator.two_factor_authentication.update(enabled: false)
      end
    end

    def mobile_authenticator_params
      params.require(:mobile_authenticator).permit(:otp_password)
    end
  end
end
