module Authentication
  class OauthResponse
    class Google
      def self.from_json(json)
        new(json)
      end

      def initialize(json)
        @json = json
      end

      def info
        @_info ||= Info.new(json["info"])
      end

      def credentials
        @_credentials ||= Credentials.new(json["credentials"])
      end

      def family_name
        info.family_name
      end

      def given_name
        info.given_name
      end

      def picture_url
        info.picture_url
      end

      def email
        info.email
      end

      def token
        credentials.token
      end

      def refresh_token
        credentials.refresh_token
      end

      def expires?
        credentials.expires?
      end

      def expires_at
        credentials.expires_at
      end

      private

      attr_reader :json

      class Info
        def initialize(json)
          @json = json
        end

        def family_name
          json["last_name"]
        end

        def given_name
          json["first_name"]
        end

        def picture_url
          json["image"]
        end

        def email
          json["email"]
        end

        private

        attr_reader :json
      end

      class Credentials
        def initialize(json)
          @json = json
        end

        def token
          json["token"]
        end

        def refresh_token
          # refresh token is only given on first authentication and not
          # passed after that
          json["refresh_token"]
        end

        def expires?
          json["expires"]
        end

        def expires_at
          json["expires_at"]
        end

        private

        attr_reader :json
      end
    end
  end
end
