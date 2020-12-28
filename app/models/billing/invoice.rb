module Billing
  class Invoice < ApplicationRecord
    include ActionView::Helpers::NumberHelper

    belongs_to :invoiceable, polymorphic: true

    has_one(
      :billing_external_id,
      class_name: "::Billing::ExternalId",
      as: :objectable
    )
    accepts_nested_attributes_for :billing_external_id

    validates :number, uniqueness: true

    enum status: {
      draft: 0,
      open: 1,
      paid: 2,
      uncollectable: 3,
      void: 4
    }

    def formatted_total
      number_to_currency(
        amount_due.to_f / 100,
        unit: ::Billing::Price::CURRENCY_SYMBOL_MAP[currency_code.downcase.to_sym]
      )
    end
  end
end
