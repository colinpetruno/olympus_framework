module Billing::Webhooks::Events
  class ChargeFailed
    def self.process(stripe_charge, payment_intent=nil)
      #payment intent is only passed on the first creation of the charge in
      #our database
      new(stripe_charge, payment_intent).process
    end

    def initialize(stripe_charge, payment_intent = nil)
      @stripe_charge = stripe_charge
      @payment_intent = payment_intent
    end

    def process
      if charge.present? && charge.failed
        return charge
      end

      if charge.blank?
        @_charge = Billing::Stripe::ChargeUpserter.for(
          stripe_charge,
          payment_intent
        )
      end

      charge.update(
        status: :failed,
        failure_code: stripe_charge.failure_code,
        failure_reason: stripe_charge.failure_message
      )
    end

    private

    attr_reader :stripe_charge, :payment_intent

    def charge
      @_charge ||= ::Billing::ExternalId.
        find_by(external_id: stripe_charge.id)&.
        objectable
    end
  end
end
