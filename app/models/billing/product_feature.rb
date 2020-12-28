module Billing
  class ProductFeature < ApplicationRecord
    belongs_to :billing_feature, class_name: "Billing::Feature"
    belongs_to :billing_product, class_name: "Billing::Product"

    enum measuring_type: {
      toggleable: 0,
      monthly_quantity: 1,
      total_quantity: 2
    }
  end
end
