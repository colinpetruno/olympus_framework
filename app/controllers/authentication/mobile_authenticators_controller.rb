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
        end

        redirect_to(
          new_auth_two_factor_authentication_path,
          flash: { success: "Mobile authenticator settings applied" }
        )
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
