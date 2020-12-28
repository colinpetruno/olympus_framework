module Billing::Webhooks::Events
  class PriceCreated
    def self.process(stripe_event)
      new(stripe_event).process
    end

    def initialize(stripe_event)
      @stripe_event = stripe_event
    end

    def process
      Billing::Stripe::PriceUpserter.for(stripe_price)
    end

    private

    attr_reader :stripe_event

    def stripe_price
      stripe_event.data.object
    end
  end
end
