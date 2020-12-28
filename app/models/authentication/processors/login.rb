module Authentication
  module Processors
    class Login
      def self.for(oauth_response)
        new(oauth_response).create
      end

      def initialize(oauth_response)
        @oauth_response = oauth_response
      end

      def create
        Authentication::CredentialsUpdater.for(oauth_response)

        BrokenAuthRecord.where(
          member_id: member.id,
          reconnected_at: nil,
          provider: oauth_response.provider
        ).update(
          reconnected_at: DateTime.now
        )
      end

      private

      attr_reader :oauth_response

      def member
        @_member ||= Members::Finder.by_email!(oauth_response.email)
      end
    end
  end
end
