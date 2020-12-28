module Billing::Stripe
  class PriceUpserter
    def self.for(stripe_price)
      new(stripe_price).upsert
    end

    def initialize(stripe_price)
      @stripe_price = stripe_price
    end

    def upsert
      objectable = nil

      external_id = ::Billing::ExternalId.find_by(
        external_id: stripe_price.id
      )

      product = external_id&.objectable

      if product.blank?
        # for some reason the product doesn't exist, find the product and
        # import it to ensure we have it correctly
        stripe_product = Stripe::Product.retrieve(
          stripe_price.product,
        )

        product = Billing::Stripe::ProductUpserter.for(stripe_product)
      end

      if external_id.blank?
        ApplicationRecord.transaction do
          objectable = ::Billing::Price.create(
            active: stripe_price.active,
            amount: stripe_price.unit_amount,
            billing_product: product,
            currency: stripe_price.currency,
            interval: stripe_price.recurring.interval
          )

          ::Billing::ExternalId.create!(
            objectable: objectable,
            external_id: stripe_price.id
          )
        end
      else
        objectable = external_id.objectable

        objectable.update(
          active: stripe_price.active,
          interval: stripe_price.recurring.interval,
          amount: stripe_price.unit_amount,
          currency: stripe_price.currency
        )
      end
    end

    private

    attr_reader :stripe_price
  end
end
