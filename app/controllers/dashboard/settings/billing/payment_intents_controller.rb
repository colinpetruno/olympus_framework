module Dashboard
  module Settings
    module Billing
      class PaymentIntentsController < AuthenticatedController
        layout "billing"

        def create
          # subscription = ::Billing::Subscription
          # TODO: check for logic to ensure it is in fact a new subscription
          subscription = ::Billing::Subscription.find_by(
            active: true,
            ownerable: session_info.account
          )

          if subscription.blank?
            subscription = ::Billing::Subscription.create(
              active: false,
              ownerable: session_info.account,
              subscribeable_id: payment_intent_params[:payable_id],
              subscribeable_type: payment_intent_params[:payable_type]
            )
          end

          @payment_intent = ::Billing::PaymentIntent.create!(
            payment_intent_params.merge(
              started_at: DateTime.now,
              targetable: subscription,
              billable: session_info.account
            )
          )

          redirect_to(dashboard_settings_billing_payment_intent_path(
            @payment_intent
          ))
        end

        def show
          @payment_intent = ::Billing::PaymentIntent.find_by!(
            profile: session_info.profile,
            uuid: params[:id]
          )

          # a companies for us has one subscription, more complicated systems
          # may rely on a different owner if they support multiple
          # subscriptions per company (perhaps a product)
          @billing_subscription = ::Billing::Subscription.find_by(
            ownerable: session_info.account,
            active: true
          )

          @billing_price = ::Billing::SubscriptionPrice.new(
            billing_subscription: @billing_subscription,
            selected_price: @payment_intent.payable,
            session_info: session_info
          )

          @billing_sources = ::Billing::SourceFinder.for(session_info)
        end

        def update
          @payment_intent = ::Billing::PaymentIntent.find_by!(uuid: params[:id])

          # find the customer in stripe for this company
          @billing_customer = ::Billing::CustomerFinder.for(session_info)

          # We will create the card in stripe and associate it to the  user
          # if they entered new billing details. This is done first so that
          # we can persist that information early
          if payment_intent_params[:billing_source_id] == "new_card"
            @payment_intent.assign_attributes(billing_detail_params)

            if @payment_intent.valid?
              # NOTE: reseting this to be safe, might be okay removing this
              @payment_intent.reload
            else
              # Set the stuff needed for show
              @billing_subscription = ::Billing::Subscription.find_by(
                ownerable: session_info.account,
                active: true
              )

              @billing_price = ::Billing::SubscriptionPrice.new(
                billing_subscription: @billing_subscription,
                selected_price: @payment_intent.payable,
                session_info: session_info
              )

              @billing_sources = ::Billing::SourceFinder.for(session_info)

              # now we need to render the show again
              render "show" and return
            end
            # remove this so we don't update it to nil later
            params[:billing_payment_intent].delete(:billing_source_id)


            billing_source = ::Billing::Source.create!(
              payment_intent_source_params
            )

            @payment_intent.update(billing_source_id: billing_source.id)

            Stripe::Customer.create_source(
              @billing_customer.external_id,
              {
                source: billing_source.billing_external_id.external_id,
              }
            )
          end

          # redirect back if they have not accepted the terms yet. This is
          # after creating the card so that the card details are saved after
          # the redirect and the user doesn't need to reenter it
          if payment_intent_params[:accept_terms] != "1"
            redirect_to(dashboard_settings_billing_payment_intent_path(
              @payment_intent
            )) and return
          else
            @payment_intent.update(
              payment_intent_params.slice(:accept_terms, :external_id, :billing_source_id).merge(
                terms_accepted_on: DateTime.now
              )
            )
          end

          subscription_manager = ::Billing::Stripe::SubscriptionManager.new(
            source: @payment_intent.reload.billing_source,
            session_info: session_info,
            price: @payment_intent.payable,
            payment_intent: @payment_intent
          )

          subscription = subscription_manager.create_or_update
          stripe_subscription = subscription_manager.stripe_subscription

          if stripe_subscription&.latest_invoice&.payment_intent&.next_action.present?
            next_action = stripe_subscription&.latest_invoice&.payment_intent&.next_action

            if next_action.type.to_s == "use_stripe_sdk"
              redirect_to(
                billing_payment_intent_confirmations_path(@payment_intent)
              ) and return
            elsif next_action.type.to_s == "redirect_to_url"
              raise StandardError.new("Unsupported redirect flow")
            else
              raise StandardError.new("Unsupported next action type")
            end
          elsif subscription.active?
            redirect_to(
              dashboard_root_path,
              flash: { success: "Payment was processed successfully" }
            )
          else
            redirect_to(
              billing_payment_intent_path(@payment_intent),
              flash: { error: "Something went wrong with your payment. Check your biling details and try again" }
            ) and return
          end
        end

        private

        def default_source
          ::Billing::SourceFinder.new(session_info).default
        end

        def default_source_present?
          ::Billing::Source.
            where(
              sourceable: session_info.account,
              default: true,
              deleted_at: nil
            ).exists?
        end

        def billing_detail_params
          params.require(:billing_payment_intent).permit(
            :entity_type,
            :entity_name,
            :tax_number,
            :line_1,
            :line_2,
            :city,
            :province,
            :postalcode,
            :country_code,
            :billing_source_id
          )
        end

        def payment_intent_source_params
          params.
            require(:billing_payment_intent).
            permit(
              :exp_year,
              :exp_month,
              :brand,
              :last_four,
              {
                billing_external_id_attributes: [:external_id],
              }
            ).
            merge({
              created_by_id: session_info.profile.id,
              source_type: :card,
              sourceable: session_info.account,
              billing_detail_attributes: {
                detailable: session_info.account,
                entity_type: billing_detail_params[:entity_type],
                entity_name: billing_detail_params[:entity_name],
                tax_number: billing_detail_params[:tax_number],
                address_attributes: {
                  line_1: billing_detail_params[:line_1],
                  line_2: billing_detail_params[:line_2],
                  city: billing_detail_params[:city],
                  province: billing_detail_params[:province],
                  postalcode: billing_detail_params[:postalcode],
                  company: session_info.company
                }
              }
            })
        end

        def payment_intent_params
          params.
            require(:billing_payment_intent).
            permit(
              :payable_id,
              :payable_type,
              :accept_terms,
              :billing_source_id
            ).
            merge({
              profile: session_info.profile,
              chargeable: session_info.account
            })
        end
      end
    end
  end
end
