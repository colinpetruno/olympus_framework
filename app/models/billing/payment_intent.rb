module Billing
  class PaymentIntent < ApplicationRecord
    include NotDeletable
    include Uuidable
    # Billable = The acount / entity paying for this item
    belongs_to :billable, polymorphic: true

    # Chargeable = the person getting charged, in this case account
    belongs_to :chargeable, polymorphic: true

    # Payable is the distinct price being paid for
    belongs_to :payable, polymorphic: true

    # If they are paying for something that needs associated after the fact
    # (like a subscription),
    belongs_to :targetable, polymorphic: true

    # These are optional since they will be selecting these items through the
    # payment cycle
    belongs_to :billing_detail, class_name: "::Billing::Detail", required: false
    belongs_to :billing_source, class_name: "::Billing::Source", required: false
    belongs_to :billing_invoice, class_name: "::Billing::Invoice", required: false
    # NOTE: off_flow payments have no associated profile taking action
    belongs_to :profile, optional: true

    has_one(
      :billing_external_id,
      class_name: "::Billing::ExternalId",
      as: :objectable
    )
    accepts_nested_attributes_for :billing_external_id

    # these are so we can collect a new card to save on the receipt page
    attr_accessor :accept_terms, :external_id, :exp_year, :exp_month, :brand,
      :last_four, :entity_name, :tax_number, :line_1, :line_2, :city,
      :province, :postalcode, :country_code, :entity_type

    # NOTE: this is to validate the payment_intent#show form, why 0? because
    # new_card as a string will get converted to 0 when assigned.
    validates(
      :entity_name, :line_1, :city, :country_code, :postalcode, :entity_type,
      presence: true,
      if: Proc.new { |r| r.billing_source_id == 0 }
    )

    enum status: {
      processing: 0,
      succeeded: 1,
      canceled: 2,
      requires_payment_method: 3,
      requires_confirmation: 4,
      requires_action: 5,
      requires_capture: 6
    }
  end
end
