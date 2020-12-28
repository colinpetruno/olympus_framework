module Billing
  module Stripe
    class Sync
      def self.import_all
        new.perform
      end

      def self.import_products
        new.import_products
      end

      def self.import_vats
        new.import_vats
      end

      def perform
        import_products
        import_vats
      end

      def import_products
        ::Stripe::Product.list().map do |product|
          ::Billing::Stripe::ProductUpserter.for(product)

          ::Stripe::Price.list(product: product.id).map do |stripe_price|
            Billing::Stripe::PriceUpserter.for(stripe_price)
          end
        end
      end

      def import_vats
        ::Stripe::TaxRate.list.each_with_index do |vat_rate|
          Billing::Stripe::VatRateUpserter.for(vat_rate)
        end
      end

      private
    end
  end
end
