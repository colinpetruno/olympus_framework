module Authentication
  module Revokers
    class Google
      def self.revoke(auth_credential)
        new(auth_credential).revoke
      end

      def initialize(auth_credential)
        @auth_credential = auth_credential
      end

      def revoke
        # can be a token or a refresh token
        # uri = URI('https://oauth2.googleapis.com/revoke')
        uri = URI("https://accounts.google.com/o/oauth2/revoke")
        params = { token: auth_credential.refresh_token }
        uri.query = URI.encode_www_form(params)
        response = nil

        Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https') do |http|
          request = Net::HTTP::Get.new uri
          response = http.request request # Net::HTTPResponse object
        end

        if response.code == 200
          AuthCredentialLog.create(
            provider: auth_credential.provider,
            member_id: auth_credential.member_id,
            token: auth_credential.token,
            refresh_token: auth_credential.refresh_token,
            expires: auth_credential.expires,
            expires_at: auth_credential.expires_at
          )

          auth_credential.destroy

          true
        else
          JSON.parse(response.body).merge(code: response.code)
        end
      end

      private

      attr_reader :auth_credential
    end
  end
end
