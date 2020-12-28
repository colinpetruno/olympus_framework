module Billing::Stripe
  class InvoiceUpserter
    def self.for(stripe_invoice)
      new(stripe_invoice).upsert
    end

    def initialize(stripe_invoice)
      @stripe_invoice = stripe_invoice
    end

    def upsert
      objectable = nil

      external_id = ::Billing::ExternalId.find_by(
        external_id: stripe_invoice.id
      )

      if external_id.blank?
        objectable = ::Billing::Invoice.create(
          amount_due: stripe_invoice.amount_due,
          amount_paid: stripe_invoice.amount_paid,
          amount_remaining: stripe_invoice.amount_remaining,
          currency_code: stripe_invoice.currency.upcase,
          status: stripe_invoice.status,
          subtotal: stripe_invoice.subtotal,
          tax: stripe_invoice.tax || 0,
          total: stripe_invoice.total,
          invoiceable: application_account,
          number: stripe_invoice.number,
          billing_external_id_attributes: {
            external_id: stripe_invoice.id
          }
        )
      else
        objectable = external_id.objectable

        objectable.update(
          status: stripe_invoice.status,
          amount_paid: stripe_invoice.amount_paid,
          amount_due: stripe_invoice.amount_due
        )
      end

      if stripe_invoice.payment_intent.present?
        ::Billing::Stripe::PaymentIntentUpserter.for(stripe_payment_intent)
      end

      return objectable
    end

    private

    attr_reader :stripe_invoice

    def stripe_payment_intent
      @_stripe_payment_intent ||= ::Stripe::PaymentIntent.retrieve(
        stripe_invoice.payment_intent
      )
    end

    def application_account
      return @_application_account if @_application_account.present?

      customer_type = stripe_customer.metadata.application_customer_type

      @_application_account = customer_type.constantize.find(
        stripe_customer.metadata.application_customer_id
      )
    end

    def stripe_customer
      @_stripe_customer ||= ::Stripe::Customer.retrieve(
        stripe_invoice.customer
      )
    end
  end
end
