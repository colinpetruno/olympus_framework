module ExternalResources
  module Calendars
    class Subscribe < ::ExternalResources::Base
      ADAPTOR_MAP = {
        google_oauth2: ::ExternalResources::Google::Calendars::Subscriber
      }.freeze

      def initialize(calendar:, session_info: nil)
        @calendar = calendar
        @_session_info = session_info
      end

      def subscribe
        return true if subscribed?

        adaptor.subscribe
      end

      def unsubscribe
        adaptor.unsubscribe
      end

      private

      attr_reader :calendar

      def adaptor
        @_adaptor ||= ADAPTOR_MAP[calendar.provider.to_sym].new(
          session_info: session_info,
          calendar: calendar
        )
      end

      def session_info
        @_session_info ||= ::Members::SessionInfo.for(calendar.profile.member)
      end

      def subscribed?
        ::SyncSubscription.
          where("revoked_at is null").
          where(subscribeable: calendar).exists?
      end
    end
  end
end
