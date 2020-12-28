module TwoFactorAuthentications
  module Verifiers
    class Fips
      def self.verify(member, params, session)
        new(member, params, session).verify
      end

      def initialize(member, params, session)
        @member = member
        @params = params
        @session = session
      end

      def verify
        begin
          webauthn_credential.verify(
            session[:two_factor_auth_challenge],
            public_key: stored_credential.public_key,
            sign_count: stored_credential.used_count
          )

          # Update the stored credential sign count with the value from
          # `webauthn_credential.sign_count`
          stored_credential.update!(
            used_count: webauthn_credential.sign_count
          )

          auth_log = TwoFactorAuthLog.create!(
            authenticatable: stored_credential,
            authed_on: DateTime.now,
            auth_status: :succeeded,
            member: member
          )

          return auth_log
        rescue WebAuthn::SignCountVerificationError => e
          # Cryptographic verification of the authenticator data succeeded,
          # but the signature counter was less then or equal to the stored
          # value. This can have several reasons and depending on your risk
          # tolerance you can choose to fail or pass authentication. For more
          # information see https://www.w3.org/TR/webauthn/#sign-counter
          auth_log = TwoFactorAuthLog.create!(
            authenticatable: stored_credential,
            authed_on: DateTime.now,
            auth_status: :failed,
            member: member
          )

          return auth_log
        rescue WebAuthn::Error => e
          # Handle error
          auth_log = TwoFactorAuthLog.create!(
            authenticatable: stored_credential,
            authed_on: DateTime.now,
            auth_status: :failed,
            member: member
          )

          return auth_log
        end
      end

      private

      attr_reader :member, :params, :session

      def stored_credential
        @_stored_credential ||= webauthn_tokens.find_by(
          external_id: webauthn_credential.id
        )
      end

      def webauthn_credential
        @_webauthn_credential ||= WebAuthn::Credential.from_get(params)
      end

      def webauthn_tokens
        @_webauthn_tokens ||= TwoFactorAuthentications::Finder.
          for(member).
          webauthn_tokens
      end
    end
  end
end
