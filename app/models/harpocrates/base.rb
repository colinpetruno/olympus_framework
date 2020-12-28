module Harpocrates
  module Base
    extend ActiveSupport::Concern

    class_methods do
      def attr_exportable_fields
        @_attr_exportable_fields ||= []
      end

      def attr_exportable(*fields)
        fields.map do |field|
          attr_exportable_fields.push(
            ::Harpocrates::ExportableFieldConfigurer.for(self, field)
          )
        end
      end

      def attr_scrubbable_fields
        @_attr_scrubbable_fields ||= []
      end

      def attr_scrubbable(*fields)
        fields.map do |field|
          attr_scrubbable_fields.push(
            ::Harpocrates::ScrubbableFieldConfigurer.for(self, field)
          )
        end
      end
    end

    def harpocrates_export
      ::Harpocrates::FieldExporter.for(self)
    end

    def harpocrates_scrub
      ::Harpocrates::FieldScrubber.for(self)
    end
  end
end
