module Billing
  class VatRate < ApplicationRecord
    validate :only_one_default_rate

    enum inclusive_type: {
      inclusive: 0,
      exclusive: 1
    }

    has_many(
      :billing_external_ids,
      class_name: "::Billing::ExternalId",
      as: :objectable
    )

    private

    def only_one_default_rate
      if default_rate?
        ::Billing::VatRate.update_all(default_rate: false)
      end
    end
  end
end
