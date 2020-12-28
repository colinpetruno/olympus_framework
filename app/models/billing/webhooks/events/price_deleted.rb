module Billing::Webhooks::Events
  class PriceDeleted
    def self.process(stripe_event)
      new(stripe_event).process
    end

    def initialize(stripe_event)
      @stripe_event = stripe_event
    end

    def process
      stripe_id = ::Billing::ExternalId.find_by!(external_id: stripe_price.id)

      billing_price = stripe_id.objectable

      billing_price.update(
        active: false,
        deleted_at: DateTime.now
      )
    end

    private

    attr_reader :stripe_event

    def stripe_price
      stripe_event.data.object
    end
  end
end
