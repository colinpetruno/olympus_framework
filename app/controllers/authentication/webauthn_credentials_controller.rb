module Authentication
  class WebauthnCredentialsController < AuthenticatedController
    def create
      # this is a json method hit from the webauthn js controller
      webauthn_credential = WebAuthn::Credential.from_create(
        webauthn_token_params
      )

      Authentication::Webauthn::AddPublicKey.for(
        current_member,
        webauthn_credential,
        webauthn_token_params[:nickname]
      )
    end

    def destroy
      # TODO: Ensure recent reauth of token before allowing a delete
      two_factor_auth_source = TwoFactorAuthentication.find_by!(
        member: current_member,
        auth_type: :fips
      )

      credential = two_factor_auth_source.
        webauthn_credentials.
        find(params[:id])

      if credential.update(deleted_at: DateTime.now)
        redirect_to(
          new_auth_two_factor_authentication_path,
          flash: { success: "Your credential was removed." }
        )
      else
        redirect_to(
          new_auth_two_factor_authentication_path,
          flash: { error: "We could not delete this token. We sent your problem to our support team" }
        )
      end

    end

    private

    def webauthn_token_params
      params.require(:public_key_credential).permit(
        :type,
        :id,
        :nickname,
        :rawId,
        :clientExtensionResults,
        response: [:attestationObject, :clientDataJSON]
      )
    end
  end
end
