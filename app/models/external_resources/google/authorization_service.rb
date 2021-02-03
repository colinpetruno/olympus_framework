require "google/api_client/client_secrets"

module ExternalResources
  module Google
    class AuthorizationService
      def self.for(session_info)
        new(session_info)
      end

      def initialize(session_info)
        @session_info = session_info
      end

      def refresh!
        request_time = DateTime.now.to_i

        data = JSON.parse(request_token_from_google.body)

        # {
        #   "error"=>"invalid_grant",
        #   "error_description"=>"Token has been expired or revoked."
        # }
        #
        # TODO: Blogpost -> change the data["error"] hash into an object
        #

        if data["error"].present?
          AuthCredentials::ErrorHandler.for(auth_credential, data["error"])
        else
          Authentication::CredentialsUpdaterFromParams.new(
            auth_credential: auth_credential,
            params: {
              token: data["access_token"],
              expires_at: request_time + data["expires_in"]
            }
          ).update
        end
      end

      def authorization
        refresh! if auth_credential.expired?

        ::Google::APIClient::ClientSecrets.new(
          {
            web: {
              client_id: client_id,
              client_secret: client_secret,
              access_token: auth_credential.token,
              refresh_token: auth_credential.refresh_token,
              expires_at: auth_credential.expires_at
            }
          }
        ).to_authorization
      end

      private

      attr_reader :session_info

      def auth_credential
        @_auth_credential ||= session_info.provider_credential
      end

      def request_token_from_google
        Net::HTTP.post_form(
          refresh_token_endpoint,
          {
            refresh_token: auth_credential.refresh_token,
            client_id: client_id,
            client_secret: client_secret,
            grant_type: "refresh_token"
          }
        )
      end

      def refresh_token_endpoint
        URI("https://accounts.google.com/o/oauth2/token")
      end

      def client_id
        Rails.application.credentials.google[:client_id]
      end

      def client_secret
        Rails.application.credentials.google[:client_secret]
      end
    end
  end
end
