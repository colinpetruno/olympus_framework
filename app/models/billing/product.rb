module Billing
  class Product < ApplicationRecord
    has_many(
      :billing_prices,
      class_name: "::Billing::Price",
      foreign_key: :billing_product_id
    )

    has_many(
      :billing_product_features,
      class_name: "Billing::ProductFeature",
      foreign_key: :billing_product_id
    )
    accepts_nested_attributes_for :billing_product_features
  end
end
