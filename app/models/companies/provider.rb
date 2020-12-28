module Companies
  class Provider
    EXTERNAL_RESOURCES = {
      google: ExternalResources::Google
    }.freeze

    OMNIAUTH_PROIVDER_MAP = {
      google: :google,
      google_oauth2: :google
    }.freeze

    def self.for(company)
      new(company: company).provider
    end

    def initialize(company:)
      @company = company
    end

    def provider
      OMNIAUTH_PROIVDER_MAP[company.provider.to_sym].to_sym
    end

    def external_resource_base
      EXTERNAL_RESOURCES[provider]
    end

    private

    attr_reader :company
  end
end
