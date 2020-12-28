module Dashboard
  module Onboarding
    class CalendarsController < AuthenticatedController
      layout "billing"

      def index
        @calendars = ::Calendars::Finder.new(session_info).primary_then_alphabetical
      end
    end
  end
end
