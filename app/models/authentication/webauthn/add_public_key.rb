module Authentication
  module Webauthn
    class AddPublicKey
      def self.for(member, public_key, nickname)
        new(member: member, public_key: public_key, nickname: nickname).add
      end

      def initialize(member:, public_key:, nickname:)
        @member = member
        @nickname = nickname
        @public_key = public_key
      end

      def add
        credential = nil

        ApplicationRecord.transaction do
          credential = WebauthnCredential.create(
            two_factor_authentication: webauthn_two_factor_auth,
            external_id: public_key.id,
            public_key: public_key.public_key,
            nickname: nickname,
            used_count: public_key.sign_count
          )

          webauthn_two_factor_auth.update(enabled: true)
        end

        credential
      end

      private

      attr_reader :member, :public_key, :nickname

      def webauthn_two_factor_auth
        TwoFactorAuthentication.find_or_create_by(
          member: member,
          auth_type: :fips
        ) do |auth|
          auth.primary = true
        end
      end
    end
  end
end
