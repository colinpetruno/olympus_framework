module Authentication
  class TwoFactorSessionsController < AuthenticatedController
    layout "art_pane/authentication"

    def new
      @auth_methods = TwoFactorAuthentications::AuthMethods.
        for(current_member)

      @options = WebAuthn::Credential.
        options_for_get(allow: webauthn_formatted_tokens)

      session[:two_factor_auth_challenge] = @options.challenge

      if @auth_methods.blank?
        redirect_to new_auth_two_factor_authentication_path and return
      end

      respond_to do |format|
        format.html
        format.js # will create the modal with proper creds
      end
    end

    def create
      if invalid_auth_type?
        render(nothing: true, status: :bad_request) and return
      end

      @auth_log = nil
      verified = false

      if params[:auth_type].to_sym == :fips
        @auth_log = TwoFactorAuthentications::Verifiers::Fips.verify(
          current_member,
          webauthn_token_params,
          session
        )
      elsif params[:auth_type].to_sym == :mobile_authenticator
        @auth_log = TwoFactorAuthentications::Verifiers::MobileAuthenticator.
          verify(
            current_member,
            mobile_authenticator_params
          )
      else
        raise StandardError.new()
      end

      # This is quite an extensive endpoint, depending on how it's called we
      # might respond to the auth in a variety of ways. JS requests will emit
      # an event on successful auth, JSON will return details of which auth
      # it was and html will direct onto the authenticated resource they were
      # trying to access
      if @auth_log.succeeded? == true
        session[:two_factor_authed_at] = DateTime.now.utc.to_i
        session[:two_factor_last_activity] = DateTime.now.utc.to_i

        respond_to do |format|
          # used for mobile authenticators redemptions
          format.js

          # used for posting mobile auth
          format.html do
            redirect_to(
              post_auth_redirect_path,
              flash: { success: "Two factor auth verified" }
            )
          end

          # used for  webauthn
          format.json do
            render json: {
              id: @auth_log.id,
              redirect_url: post_auth_redirect_path
            }
          end
        end
      else
        respond_to do |format|
          format.js do
            head(:unauthorized)
          end

          format.html do
            redirect_to(
              new_auth_two_factor_session_path,
              flash: { error: "Could not verify your credentials" }
            )
          end

          format.json do
            head(:unauthorized)
          end
        end
      end
    end

    private

    def post_auth_redirect_path
      session[:two_factor_redirect_url] || root_path
    end

    def invalid_auth_type?
      return true if params[:auth_type].blank?

      [:fips, :mobile_authenticator].exclude?(params[:auth_type].to_sym)
    end

    def mobile_authenticator_params
      params.require(:mobile_authenticator).permit(:otp_password)
    end

    def webauthn_token_params
      params.require(:public_key_credential).permit(
        :id,
        :rawId,
        :clientExtensionResults,
        :type,
        response: [
          :authenticatorData,
          :clientDataJSON,
          :signature,
          :userHandle
        ]
      )
    end

    def webauthn_formatted_tokens
      webauthn_tokens.map do |token|
        {
          type: "public-key",
          id: token.external_id
        }
      end
    end

    def webauthn_tokens
      @_webauthn_tokens ||= TwoFactorAuthentications::Finder.
        for(current_member).
        webauthn_tokens
    end
  end
end
