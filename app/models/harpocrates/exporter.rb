module Harpocrates
  module Exporter
    extend ActiveSupport::Concern

    def export
      structure.deep_transform_values do |value|
        if ["Array", "ActiveRecord::Relation", "ActiveRecord::Associations::CollectionProxy"].include?(value.class.name)
          if value.respond_to?(:map)
            value.map do |item|
              item.harpocrates_export
            end
          else
            value.harpocrates_export
          end
        end
      end
    end
  end
end
