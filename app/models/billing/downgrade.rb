module Billing
  class Downgrade < ApplicationRecord
    belongs_to :billing_subscription, class_name: "::Billing::Subscription"

    encrypted_fields :reason
    attr_scrubbable :reason
    attr_exportable :reason

    # TODO: Add who did it (profile_id)
  end
end
