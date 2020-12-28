module TwoFactorAuthentications
  class Finder
    def self.for(member)
      new(member)
    end

    def initialize(member)
      @member = member
    end

    def mobile_authenticator
      mobile_auth.mobile_authenticator
    end

    def mobile_auth_enabled?
      mobile_auth.enabled?
    end

    def webauthn_tokens
      return [] if fips_authentication.blank?

      WebauthnCredential.where(
        deleted_at: nil,
        two_factor_authentication: fips_authentication
      )
    end

    private

    attr_reader :member

    def fips_authentication
      @_fips_authentication ||= auth_types.
        to_a.
        find { |auth_type| auth_type.auth_type.to_sym == :fips }
    end

    def mobile_auth
      @_mobile_auth ||= auth_types.
        to_a.
        find { |auth_type| auth_type.auth_type.to_sym == :mobile_authenticator}
    end

    def auth_types
      @_auth_types ||= TwoFactorAuthentication.where(
        member: member
      )
    end
  end
end
