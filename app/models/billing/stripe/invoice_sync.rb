module Billing::Stripe
  class InvoiceSync
    def self.for(stripe_invoice)
      new(stripe_invoice).sync
    end

    def initialize(stripe_invoice)
      @stripe_invoice = stripe_invoice
    end

    def sync
      return invoice
    end

    private

    attr_reader :stripe_invoice

    def invoice
      @_invoice ||= find_or_create_invoice
    end

    def find_or_create_invoice
      ::Billing::Stripe::InvoiceUpserter.for(stripe_invoice_object)
    end

    def stripe_invoice_object
      # we will reload this just in case the webhook is delayed or out of
      # sync to ensure we have the latest and most accurate data in the invoice
      # table
      @_stripe_invoice_object ||= ::Stripe::Invoice.retrieve(
        stripe_invoice.id
      )
    end
  end
end
