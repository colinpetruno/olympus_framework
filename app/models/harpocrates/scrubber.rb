module Harpocrates
  module Scrubber
    extend ActiveSupport::Concern

    def scrub
      structure.deep_transform_values do |value|
        if ["Array", "ActiveRecord::Relation"].include?(value.class.name)
          value.map do |item|
            new_values = item.harpocrates_export

            if new_values.present?
              item.update_columns(new_values)
            end
          end
        else
          new_values = value.harpocrates_export

          if new_values.present?
            value.update_columns(new_values)
          end
        end
      end
    end
  end
end
