module Billing
  class Feature < ApplicationRecord
    has_many(
      :billing_product_features,
      class_name: "Billing::ProductFeature",
      foreign_key: "billing_feature_id"
    )
    accepts_nested_attributes_for :billing_product_features

    validates :feature_name, :feature_key, presence: true
    validates :feature_key, format: { with: /\A[a-z_]+\Z/ }
    validates :quantity, numericality: {
      only_integer: true,
      greater_than_or_equal_to: 0
    }

    enum measuring_type: {
      toggleable: 0,
      monthly_quantity: 1,
      total_quantity: 2
    }

    def self.measuring_type_options
      measuring_types.keys.map do |key|
        [key.humanize, key]
      end
    end
  end
end
