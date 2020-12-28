module Dashboard
  module MeetingTemplates
    class IndexPresenter
      def initialize(session_info)
        @session_info = session_info
      end

      def meeting_templates
        session_info.
          profile.
          meeting_templates.
          includes(:meeting_template_synced_calendars)
      end

      def next_image
        image_cycler.next_small_image
      end

      private

      attr_reader :session_info

      def image_cycler
        @_image_cycler ||= DefaultImageCycler.new
      end
    end
  end
end
