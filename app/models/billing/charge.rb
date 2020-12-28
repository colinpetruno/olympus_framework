module Billing
  class Charge < ApplicationRecord
    belongs_to(
      :billing_source,
      class_name: "::Billing::Source"
    )

    belongs_to(
      :billing_invoice,
      class_name: "::Billing::Invoice"
    )

    belongs_to(
      :billing_payment_intent,
      class_name: "::Billing::PaymentIntent"
    )

    has_one(
      :billing_external_id,
      class_name: "::Billing::ExternalId",
      as: :objectable
    )

    enum status: {
      pending: 0,
      succeeded: 1,
      failed: 2
    }
  end
end
