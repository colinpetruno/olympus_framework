module Billing::Stripe
  class PaymentIntentUpserter
    def self.for(stripe_payment_intent)
      new(stripe_payment_intent).upsert
    end

    def initialize(stripe_payment_intent)
      @stripe_payment_intent = stripe_payment_intent
    end

    def upsert
      ::Billing::PaymentIntent.create(
        billable: subscription.ownerable,
        payable_type: billing_price,
        started_at: created_at,
        profile_id: nil, # off session payment intents might not have profiles?
        terms_accepted_on: nil,
        billing_source_id: billing_source&.id,
        status: stripe_payment_intent.status,
        targetable: subscription,
        billing_invoice_id: stripe_invoice.id,
        billing_external_id_attributes: {
          external_id: stripe_invoice.id
        }
      )

      stripe_payment_intent.charges.each do |stripe_charge|
        ::Billing::Stripe::ChargeUpserter.for(stripe_charge, payment_intent)
      end
    end

    private

    attr_reader :stripe_payment_intent

    def subscription
      ::Billing::ExternalId.
        find_by(external_id: subscription_from_invoice.id)&.
        objectable
    end

    def billing_source
      if stripe_payment_intent.source.present?
        ::Billing::ExternalId.
          find_by(external_id: stripe_payment_intent.source)&.
          objectable
      else
        nil
      end
    end

    def created_at
      Utilities::Time::UnixToDateTime.for(stripe_payment_intent.created)
    end

    def subscription_from_invoice
      stripe_invoice.lines.data.find { |obj| obj.type == "subscription" }
    end

    def stripe_invoice
      @_stripe_invoice ||= ::Stripe::Invoice.retrieve(
        stripe_payment_intent.invoice
      )
    end
  end
end
