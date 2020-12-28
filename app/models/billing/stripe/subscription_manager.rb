module Billing
  module Stripe
    class SubscriptionManager

      def initialize(source: nil, session_info:, price:, payment_intent:)
        @payment_intent = payment_intent
        @price = price
        @source = source
        @session_info = session_info
      end

      def create_or_update
        if subscription.active?
          update_subscription
        else
          create_subscription
        end

        subscription
      end

      def update_subscription
        @_stripe_subscription = ::Stripe::Subscription.update(
          subscription.billing_external_id.external_id,
          {
            default_source: source.billing_external_id.external_id,
            cancel_at_period_end: false,
            proration_behavior: "create_prorations",
            metadata: {
              application_billing_price_id: price.id,
              application_subscription_id: subscription.id
            },
            items: [
              {
                id: stripe_subscription.items.data[0].id,
                price: price.billing_external_ids.last.external_id
              }
            ],
            expand: ["latest_invoice.payment_intent"]
          }
        )

        update_app_subscription
      end

      def create_subscription
        @_stripe_subscription = ::Stripe::Subscription.create({
          default_source: source.billing_external_id.external_id,
          customer: stripe_customer_id,
          metadata: {
            application_billing_price_id: price.id,
            application_subscription_id: subscription.id
          },
          items: [
            {
              price: price.billing_external_ids.last.external_id,
              quantity: 1,
              tax_rates: []
            },
          ],
          expand: ["latest_invoice.payment_intent"]
        })

        stripe_charge = @_stripe_subscription.
          latest_invoice.
          payment_intent.
          charges.
          first

        if stripe_charge.status.to_s == "succeeded"
          # we need to know what for exactly
          Billing::Webhooks::Events::ChargeSucceeded.process(
            stripe_charge,
            payment_intent
          )
          update_app_subscription
        elsif stripe_charge.status.to_s == "failed"
          Billing::Webhooks::Events::ChargeFailed.process(
            stripe_charge,
            payment_intent
          )
        elsif stripe_charge.status.to_s == "pending"
          Billing::Webhooks::Events::ChargePending.process(
            stripe_charge,
            payment_intent
          )
        end
      end

      def subscription
        @_subscription ||= payment_intent.targetable
      end

      def stripe_subscription
        @_stripe_subscription ||= ::Stripe::Subscription.retrieve(
          subscription.billing_external_id.external_id
        )
      end

      private

      attr_reader :source, :session_info, :payment_intent, :price

      def retrieve_stripe_subscription!
        @_stripe_subscription = ::Stripe::Subscription.retrieve(
          subscription.external_id
        )
      end

      def update_app_subscription
        subscription.update(
          subscribeable: price.billing_product,
          last_paid_date: stripe_subscription.current_period_start,
          active: true,
          paid_until_date: stripe_subscription.current_period_end,
          billing_external_id_attributes: {
            id: subscription.billing_external_id.try(:id),
            external_id: stripe_subscription.id
          }
        )
      end


      def stripe_customer_id
        @_stripe_customer_id ||= ::Billing::CustomerFinder.
          for(session_info).
          billing_external_id.
          external_id
      end
    end
  end
end
