module Billing::Webhooks::Events
  class ChargeCaptured
    def self.process(stripe_charge)
      new(stripe_charge).process
    end

    def initialize(stripe_charge)
      @stripe_charge = stripe_charge
    end

    def process
      charge.update(captured: true)

      if charge.payment_intent.payment.present?
      end
    end

    private

    attr_reader :stripe_event

    def charge
      @_charge ||= find_or_create_charge
    end

    def find_or_create_charge
      if external_id.present?
        external_id.objectable
      else
        Billing::Stripe::ChargeUpserter.for(
          stripe_charge,
          payment_intent
        )
      end
    end

    def stripe_charge
      stripe_event.data.object
    end

    def external_id
      ::Billing::ExternalId.find_by(external_id: stripe_charge.id)
    end
  end
end
