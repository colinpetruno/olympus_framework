module ExternalResources
  module Events
    class Sync < ::ExternalResources::Base
      def initialize(session_info:, options: {})
        super(session_info: session_info, options: options)
      end

      def sync
        calendars.each do |calendar|
          ::ExternalResources::Google::Events::Sync.for(calendar)
        end
      end

      private

      def calendars
        member.active_calendars
      end
    end
  end
end
