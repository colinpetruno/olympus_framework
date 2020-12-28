module Billing
  class Subscription < ApplicationRecord
    belongs_to :ownerable, polymorphic: true
    belongs_to :subscribeable, polymorphic: true

    has_one(
      :billing_downgrade,
      -> { where(deleted_at: nil) },
      class_name: "Billing::Downgrade",
      foreign_key: "billing_subscription_id"
    )

    has_one(
      :billing_external_id,
      class_name: "::Billing::ExternalId",
      as: :objectable
    )
    accepts_nested_attributes_for :billing_external_id

    encrypted_fields :external_id

    def self.code_default
    end

    def price
      # TODO: Not sure I like this going through the subscription, perhaps it
      # is better to subscribe to the price and not the product
      if monthly?
        ::Billing::Price.find_by(
          billing_product_id: subscribeable_id,
          interval: "month"
        )
      else
        ::Billing::Price.find_by(
          billing_product_id: subscribeable_id,
          interval: "year"
        )
      end
    end

    def monthly?
      # TODO: clean this up more. I don't want to store their billing interval
      # here on this model since this should be responsible for subscribing
      # to a product but not necessarily the billing interval data
      (1.month + 4.days).to_i > (paid_until_date - last_paid_date)
    end

    def yearly?
      (1.month + 4.days).to_i < (paid_until_date - last_paid_date)
    end

    def interval
      if monthly?
        "monthly"
      else
        "yearly"
      end
    end
  end
end
