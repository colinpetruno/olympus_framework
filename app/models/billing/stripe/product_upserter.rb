module Billing::Stripe
  class ProductUpserter
    def self.for(stripe_product)
      new(stripe_product).upsert
    end

    def initialize(stripe_product)
      @stripe_product = stripe_product
    end

    def upsert
      objectable = nil

      external_id = ::Billing::ExternalId.find_by(
        external_id: stripe_product.id
      )

      if external_id.blank?
        ApplicationRecord.transaction do
          objectable = ::Billing::Product.create!(
            name: stripe_product.name,
            description: stripe_product.description
          )

          ::Billing::ExternalId.create!(
            objectable: objectable,
            external_id: stripe_product.id
          )
        end
      else
        objectable = external_id.objectable

        objectable.update(
          name: stripe_product.name,
          description: stripe_product.description,
          visible: stripe_product.active
        )
      end

      return objectable
    end

    private

    attr_reader :stripe_product
  end
end
