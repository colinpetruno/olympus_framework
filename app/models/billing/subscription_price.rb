module Billing
  class SubscriptionPrice
    include ActionView::Helpers::NumberHelper

    def initialize(billing_subscription:, selected_price:, session_info:)
      # billing_subscription is nil when the customer does not have an active
      # subscription, if they do, we need to call stripe to determine the
      # prorated amount with the new price
      @billing_subscription = billing_subscription
      @selected_price = selected_price
      @session_info = session_info
    end

    def base_price_name
      selected_price.billing_name
    end

    def base_price
      selected_price.amount
    end

    def formatted_base_price
      number_to_currency(
        base_price / 100,
        unit: selected_price.currency_symbol
      )
    end

    def discount?
      upcoming_proration != 0
    end

    def formatted_discount
      # if we have more available than the cost, max the proration at the
      # maximum (the plan price) for this transaction
      if upcoming_proration.abs >= selected_price.amount
        number_to_currency(
          selected_price.amount / 100 * -1,
          unit: selected_price.currency_symbol
        )
      else
        number_to_currency(
          upcoming_proration / 100 * -1,
          unit: selected_price.currency_symbol
        )
      end
    end

    def formatted_price
      # if we have extra proration value, the amount due could go below
      # zero. Thus we cap it to prevent people thinking they will get money
      # back right away
      if price < 0
        number_to_currency(
          0,
          unit: selected_price.currency_symbol
        )
      else
        number_to_currency(
          price / 100,
          unit: selected_price.currency_symbol
        )
      end
    end

    def price
      # this is the amount due in the subscription
      if upcoming_proration != 0
#        # for when we have negative proration that exceeds the plan cost
#        if upcoming_proration < 0 && upcoming_proration.abs >= selected_price.amount
#          0
#        else
#          # prorations less than plan cost or additive proration
#          selected_price.amount + upcoming_proration
#        end
        adjusted_invoice.amount_due
      else
        selected_price.amount
      end
    end

    def adjusted_invoice
      return nil if billing_subscription.blank?

      @_adjusted_invoice ||= ::Stripe::Invoice.upcoming({
        customer: ::Billing::CustomerFinder.for(session_info).external_id,
        subscription: billing_subscription.billing_external_id.external_id,
        subscription_items: new_items,
        subscription_proration_date: DateTime.now.to_i
      })
    end

    def formatted_line_item_price(stripe_line_item)
      # TODO: this could introduce a bug where if the price is a different
      # currency than their current subscription
      divided_price = stripe_line_item.amount.to_f / 100.to_f
      number_to_currency(divided_price, unit: selected_price.currency_symbol)
    end

    def upcoming_proration
      return 0 if billing_subscription.blank?


#      adjusted_invoice["lines"]["data"].select do |obj|
#        obj.type == "invoiceitem"
#      end.sum(&:amount)

      selected_price.amount - adjusted_invoice.amount_due
    rescue StandardError => error
      Errors::Reporter.notify(error)

      0
    end

    private

    attr_reader :billing_subscription, :selected_price, :session_info


    def new_items
      [{ id: current_item_id, price: selected_price.billing_external_ids.first.external_id }]
    end

    def current_item_id
      current_billing_subscription.items.data.first.id
    end

    def current_billing_subscription
      @_current_billing_subscription ||= ::Stripe::Subscription.retrieve(
        billing_subscription.billing_external_id.external_id
      )
    end
  end
end
