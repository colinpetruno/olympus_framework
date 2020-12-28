module Billing
  class PlanWithPrice
    attr_reader :plan

    def initialize(plan, prices=nil)
      @plan = plan
      @prices = prices
    end

    def yearly_price
      prices.find { |price| price.interval == "month" }.amount
    end

    def monthly_price
      prices.find { |price| price.interval == "year" }.amount
    end


    def name
      plan.name
    end

    def plan_id
      plan.id
    end

    private

    def prices
      @prices ||= plan.places
    end
  end
end
