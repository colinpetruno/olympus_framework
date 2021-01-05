module Authentication
  class TwoFactorAuthenticationsController < AuthenticatedController
    layout "art_pane/authentication"

    before_action -> (redirect_path = determine_redirect_path) do
      require_password_confirmation_if_needed(redirect_path)
    end, only: :new

    def new
      Authentication::AuditTwoFactorRecords.for(current_member)
      @two_factor_auths = TwoFactorAuthentications::Finder.for(current_member)

      # TODO: extract to config
      issuer = if Rails.env.production?
                 I18n.t("base.application_name")
               else
                 "#{I18n.t("base.application_name")}_#{Rails.env}"
               end

      totp = ROTP::TOTP.new(
        @two_factor_auths.mobile_authenticator.otp_base,
        issuer: issuer
      )

      @mobile_auth = totp.provisioning_uri(
        current_member.email
      )

      @qrcode = RQRCode::QRCode.new(@mobile_auth)

      @webauthn_options = WebAuthn::Credential.options_for_create(
        user: {
          id: current_member.webauthn_id,
          name: current_member.profile.full_name
        },
        exclude: []
      )

      @webauthn_credentials = @two_factor_auths.webauthn_tokens

      session[:creation_challenge] = @webauthn_options.challenge
    end

    def determine_redirect_path
      session[:password_confirmation_redirect] || nil
    end
  end
end
