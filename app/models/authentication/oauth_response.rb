module Authentication
  class OauthResponse
    class Error < StandardError; end;

    PROVIDERS = {
      google_oauth2: ::Authentication::OauthResponse::Google
    }.freeze

    def self.for(response, session_info=nil)
      new(response, session_info)
    end

    def initialize(response, session_info=nil)
      @response = response
      @session_info = session_info
    end

    def provider_adaptor
      @_provider_adaptor ||= PROVIDERS[provider.to_sym].new(response)
    end

    def family_name
      provider_adaptor.family_name
    end

    def given_name
      provider_adaptor.given_name
    end

    def picture_url
      provider_adaptor.picture_url
    end

    def email
      provider_adaptor.email.downcase
    end

    def email_domain
      email.split("@").last
    end

    def token
      provider_adaptor.token
    end

    def refresh_token
      provider_adaptor.refresh_token
    end

    def expires?
      provider_adaptor.expires?
    end

    def expires_at
      provider_adaptor.expires_at
    end

    def domain_admin?
      # determine if we can manage all domain settings from this connection
      # hardcoded to false for now but will need to figure out how to best
      # set up that connection to google
      false
    end

    def provider
      local_provider = response["provider"]

      if local_provider.blank? || PROVIDERS.keys.exclude?(local_provider.to_sym)
        raise_invalid_provider(local_provider)
      end

      local_provider
    end

    def session_info
      @session_info
    end

    private

    attr_reader :response

    def raise_invalid_provider(provider_name)
      raise Error.new("Provider '#{provider_name}' is invalid.")
    end
  end
end
