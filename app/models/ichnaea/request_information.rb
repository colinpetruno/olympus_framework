module Ichnaea
  class RequestInformation
    def self.for(request)
      new(request).as_json
    end

    def initialize(request)
      @request = request
    end

    def as_json(_opts={})
      {
        domain: request.domain,
        referrer: request.referrer,
        base_url: request.base_url,
        http_method: request.method,
        host: request.host,
        fullpath: request.fullpath,
        language: request.accept_language,
        ip: request.remote_ip,
        origin: request.origin,
        url: request.original_url,
        query_string: request.query_string,
        query_parameters: request.query_parameters,
        subdomain: request.subdomain,
        user_agent: request.user_agent
      }
    end

    private

    attr_reader :request
  end
end
