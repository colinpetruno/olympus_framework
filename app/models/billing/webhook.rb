module Billing
  class Webhook < ApplicationRecord
    encrypted_fields :payload
    validates :payload, presence: true

    enum provider: {
      stripe: 0
    }

    enum process_status: {
      pending: 0,
      processing: 1,
      succeeded: 2,
      failed: 3,
      skipped: 4,
      not_implemented: 5
    }
  end
end
