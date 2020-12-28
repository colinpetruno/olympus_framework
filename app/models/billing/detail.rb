module Billing
  class Detail < ApplicationRecord
    belongs_to :detailable, polymorphic: true

    has_one :address, as: :addressable
    has_one :current_product, class_name: "::Billing::Product"

    accepts_nested_attributes_for :address

    encrypted_fields :tax_number, :entity_name
    attr_scrubbable :tax_number

    enum entity_type: {
      individual: 0,
      business: 1
    }

    def self.entity_options
      self.entity_types.keys.map do |entity_type|
        [entity_type.capitalize, entity_type]
      end
    end
  end
end
