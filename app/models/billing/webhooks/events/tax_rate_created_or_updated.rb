module Billing::Webhooks::Events
  class TaxRateCreatedOrUpdated
    def self.process(stripe_event)
      new(stripe_event).process
    end

    def initialize(stripe_event)
      @stripe_event = stripe_event
    end

    def process
      Billing::Stripe::VatRateUpserter.for(stripe_tax_rate)
    end

    private

    attr_reader :stripe_event

    def stripe_tax_rate
      stripe_event.data.object
    end
  end
end
