module Billing::Webhooks::Events
  class ProductCreatedOrUpdated
    def self.process(stripe_event)
      new(stripe_event).process
    end

    def initialize(stripe_event)
      @stripe_event = stripe_event
    end

    def process
      Billing::Stripe::ProductUpserter.for(stripe_product)

      # NOTE: This might be redundent but will help ensure that the prices
      # stay in sync. If there are deadlocks then things should be okay if this
      # part is removed
      ::Stripe::Price.list(product: stripe_product.id).map do |stripe_price|
        Billing::Stripe::PriceUpserter.for(stripe_price)
      end
    end

    private

    attr_reader :stripe_event

    def stripe_product
      stripe_event.data.object
    end
  end
end
