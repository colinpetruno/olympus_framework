module Authentication
  class AuditTwoFactorRecords
    def self.for(member)
      new(member).audit
    end

    def initialize(member)
      @member = member
    end

    def audit
      # ensure the member has their base webauthn token
      if member.webauthn_id.blank?
        member.update!(webauthn_id: WebAuthn.generate_user_id)
      end

      TwoFactorAuthentication.auth_types.keys.each do |auth_type|
        if select_auth_type(auth_type).blank?
          auth = TwoFactorAuthentication.create!(
            member: member,
            auth_type: auth_type,
            enabled: false
          )
        end
      end

      # if there is no base otp, we can create it so it's ready to auth with
      # in the UI
      mobile_auth_record = select_auth_type(:mobile_authenticator)
      if mobile_auth_record.mobile_authenticator.blank?
        mobile_auth_record.create_mobile_authenticator(
          otp_base: Base32.encode(SecureRandom.hex(32)).first(64),
          enabled: false
        )
      end
    end

    private

    attr_reader :member

    def select_auth_type(auth_type)
      auth_types.reload.to_a.find do |at|
        at.auth_type.to_sym == auth_type.to_sym
      end
    end

    def auth_types
      TwoFactorAuthentication.where(
        member: member
      )
    end
  end
end
