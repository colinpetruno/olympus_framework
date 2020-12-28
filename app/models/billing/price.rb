module Billing
  class Price < ApplicationRecord
    include ActionView::Helpers::NumberHelper
    belongs_to :billing_product, class_name: "::Billing::Product"

    has_many(
      :billing_external_ids,
      class_name: "::Billing::ExternalId",
      as: :objectable
    )

    CURRENCY_SYMBOL_MAP = {
      eur: "€",
      usd: "$"
    }

    def billing_name
      [billing_product.name, formatted_interval].join(" - ")
    end

    def formatted_interval
      # TODO: I18n, fix billing_products#edit
      if interval == "month"
        "Monthly"
      else
        "Yearly"
      end
    end

    def currency_symbol
      CURRENCY_SYMBOL_MAP[currency.to_sym]
    end

    def formatted_price
      number_to_currency(
        amount.to_f / 100,
        unit: CURRENCY_SYMBOL_MAP[currency.to_sym]
      )
    end
  end
end
