module ExternalResources
  module Google
    class Base
      def initialize(session_info:)
        @session_info = session_info
      end

      private

      attr_reader :session_info

      def connection
        @_connection ||= new_connection
      end

      def new_connection
        service = service_class.new
        # service.client_options.application_name = "Meetrics"
        service.authorization = authorization_service.authorization

        service
      end

      def authorization_service
        @_authorization_service ||= authorization_service_class.
          for(session_info)
      end

      def authorization_service_class
        ::ExternalResources::Google::AuthorizationService
      end
    end
  end
end
