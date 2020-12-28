module Billing::Products
  class FeatureAuditor
    def self.for(billing_product)
      new(billing_product: billing_product).audit
    end

    def initialize(billing_product:)
      @billing_product = billing_product
    end

    def audit
      return true if new_feature_ids.blank?

      Billing::Feature.where(id: new_feature_ids).each do |billing_feature|
        @billing_product.billing_product_features.create!(
          billing_feature: billing_feature,
          measuring_type: billing_feature.measuring_type,
          quantity: billing_feature.quantity,
          enabled: billing_feature.enabled?,
          unlimited: billing_feature.unlimited?
        )
      end
    end

    private

    attr_reader :billing_product

    def new_feature_ids
      all_features.map(&:id) - existing_features.map(&:billing_feature_id)
    end

    def all_features
      @_all_features ||= ::Billing::Feature.all
    end

    def existing_features
      @_existing_features = billing_product.billing_product_features
    end
  end
end
