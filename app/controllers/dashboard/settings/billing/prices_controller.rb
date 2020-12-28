module Dashboard
  module Settings
    module Billing
      class PricesController < AuthenticatedController
        layout "billing"

        def index
          @current_plan = ::Billing::Subscription.find_by(
            active: true,
            ownerable: session_info.account
          )

          if params[:product_id] == "free"
            if @current_plan.present? && @current_plan.cancelled_at.blank?
              render "downgrade" and return
            else
              redirect_to dashboard_settings_billings_path and return
            end
          else
            @prices = ::Billing::Price.where(
              billing_product_id: params[:product_id]
            )
          end
        end
      end
    end
  end
end
