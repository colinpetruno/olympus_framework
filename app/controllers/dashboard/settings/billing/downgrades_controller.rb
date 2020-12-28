module Dashboard::Settings::Billing
  class DowngradesController < AuthenticatedController
    def create
      @current_plan = ::Billing::Subscription.find_by(
        active: true,
        ownerable: session_info.account,
        cancelled_at: nil
      )

      if @current_plan.blank?
        redirect_to dashboard_settings_billings_path and return
      end

      ::Billing::Downgrade.create!(downgrade_params.merge(
        billing_subscription_id: @current_plan.id
      ))

      @current_plan.update!(cancelled_at: DateTime.now)

      Stripe::Subscription.update(
        @current_plan.billing_external_id.external_id,
        { cancel_at_period_end: true }
      )

      # we need to do lots here

      redirect_to dashboard_settings_billings_path
    end

    def update
      @billing_downgrade = ::Billing::Downgrade.find(params[:id])

      # TODO: pundit
      if @billing_downgrade.billing_subscription.ownerable != session_info.account
        redirect_to root_path and return
      end

      @current_plan = ::Billing::Subscription.find_by(
        active: true,
        ownerable: session_info.account
      )

      @current_plan.update!(cancelled_at: nil)
      @billing_downgrade.update(deleted_at: DateTime.now)

      ::Stripe::Subscription.update(
        @current_plan.billing_external_id.external_id,
        { cancel_at_period_end: false }
      )

      redirect_to dashboard_settings_billings_path
    end

    private

    def downgrade_params
      params.
        require(:billing_downgrade).
        permit(:reason).
        merge({
          profile_id: session_info.profile.id,
          downgraded_at: DateTime.now
        })
    end
  end
end
