module Billing
  class Customer < ApplicationRecord
    belongs_to :customerable, polymorphic: true

    has_one(
      :billing_external_id,
      class_name: "::Billing::ExternalId",
      as: :objectable
    )

    encrypted_fields :external_id

    enum provider: {
      stripe: 0
    }
  end
end
