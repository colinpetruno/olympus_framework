module ExternalResources
  module Calendars
    class List < ::ExternalResources::Base
      # Note this class inherits from this external resource base controller
      # but we should remove this. I initially assumed that session_info would
      # be enough but I think it makes sense to allow many different calendar
      # providers instead of 1 provider per account. This lets people sync
      # calendars between providers

      def initialize(session_info:, options: {})
        super(session_info: session_info, options: options)

        @current_page = options[:current_page]
      end

      def get_all
        adaptor.get_all
      end

      private

      attr_reader :current_page

      def default_options
        {
          current_page: 1
        }
      end
    end
  end
end
