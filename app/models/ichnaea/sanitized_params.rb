module Ichnaea
  class SanitizedParams
    UNPERMITTED_PARAMS = %w(
      _method
      authenticity_token
      commit
    )

    PERMITTED_PARAMS = %w(
      controller
      action
    )

    UTM_PARAMS = %w(
      utm_source
      utm_medium
      utm_campaign
      utm_term
      utm_content
    )

    def self.for(params)
      new(params).clean
    end

    def self.utms(params)
      new(params).utms
    end

    def initialize(params)
      @params = params
    end

    def clean
      # use the splat operator here to convert the array to params
      # as_json ensures both param objects and hashes work
      params.as_json.except(*UNPERMITTED_PARAMS)
    end

    def utms
      params.as_json.slice(*UTM_PARAMS)
    end

    private

    attr_reader :params
  end
end
