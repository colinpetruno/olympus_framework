module Billing
  class PlansWithPrices
    def self.collect
      new.collect
    end

    def collect
      plans.map do |plan|
        ::Billing::PlanWithPrice.new(plan, plan.billing_prices)
      end
    end

    private

    def plans
      ::Billing::Product.
        where(visible: true).
        includes(:billing_prices)
    end
  end
end
