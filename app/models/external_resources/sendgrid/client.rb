module ExternalResources
  module Sendgrid
    class Client
      def client
        @_client ||= SendGrid::API.new(
          api_key: Rails.application.credentials.sendgrid_api_key
        ).client
      end
    end
  end
end
