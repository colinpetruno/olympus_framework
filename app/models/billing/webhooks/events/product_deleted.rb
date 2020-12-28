module Billing::Webhooks::Events
  class ProductDeleted
    def self.process(stripe_event)
      new(stripe_event).process
    end

    def initialize(stripe_event)
      @stripe_event = stripe_event
    end

    def process
      stripe_id = ::Billing::ExternalId.find_by!(external_id: stripe_product.id)

      billing_product = stripe_id.objectable

      billing_product.update(
        visible: false,
        deleted_at: DateTime.now
      )
    end

    private

    attr_reader :stripe_event

    def stripe_product
      stripe_event.data.object
    end
  end
end
