require "google/apis/calendar_v3"

module ExternalResources
  module Google
    module Calendars
      class Base < ::ExternalResources::Google::Base
        def service_class
          ::Google::Apis::CalendarV3::CalendarService
        end
      end
    end
  end
end
