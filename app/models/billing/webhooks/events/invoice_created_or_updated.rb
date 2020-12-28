module Billing::Webhooks::Events
  class InvoiceCreatedOrUpdated
    def self.process(stripe_event)
      new(stripe_event).process
    end

    def initialize(stripe_event)
      @stripe_event = stripe_event
    end

    def process
      Billing::Stripe::InvoiceSync.for(stripe_invoice)
    end

    private

    attr_reader :stripe_event

    def stripe_invoice
      # we want to always fetch the latest from the API in case that the
      # webhooks are not sent in the correct order.
      Stripe::Invoice.retrieve(stripe_event.data.object.id)
    end
  end
end
