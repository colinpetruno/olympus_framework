module Billing::Webhooks::Events
  class ChargeSucceeded
    # NOTE: A succeeded message only shows that the customer has the balance
    # and it passes the fraud. At this point the money is moved to the held
    # portion of their credit line / balance. We have up to 1 week to
    # "capture" the charge. Once a charge is "captured" then the money is
    # transferred.


    def self.process(stripe_charge, payment_intent=nil)
      new(stripe_charge, payment_intent).process
    end

    def initialize(stripe_charge, payment_intent=nil)
      # payment intent will only be passed on the first time a charge is
      # created
      @stripe_charge = stripe_charge
      @payment_intent = payment_intent
    end

    def process
      if charge.present? && !charge.pending? && charge.billing_payment.present?
        # skip processing already succeeded and was processed
        return true
      end

      @_charge = Billing::Stripe::ChargeUpserter.for(
        stripe_charge,
        payment_intent
      )

      # Adding this to memoize before it hits the transaction. Otherwise we
      # could hit deadlocks as these webhooks are going to cause chaos when
      # they are all sent in random orders and times
      # scope here matters
      invoice_for_charge
      payment = nil

      ApplicationRecord.transaction do
        # update the payment intent to succeeded
        payment_intent.update(status: :succeeded)
        # update the charge to succeeded
        charge.update(status: :succeeded)
      end

      return payment
    end

    private

    attr_reader :stripe_charge

    def fetch_invoice
      # Memoizing this outside of the database transaction
      invoice_for_charge
    end

    def invoice_for_charge
      @_invoice_for_charge ||= Stripe::Invoice.retrieve(
        stripe_charge.invoice
      )
    end

    def payment_intent
      @payment_intent || charge.billing_payment_intent
    end

    def charge
      @_charge ||= ::Billing::ExternalId.
        find_by(external_id: stripe_charge.id)&.
        objectable
    end
  end
end
