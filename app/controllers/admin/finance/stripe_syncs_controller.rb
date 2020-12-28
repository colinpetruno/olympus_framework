module Admin::Finance
  class StripeSyncsController < AdminController
    def create
      Billing::Stripe::Sync.perform

      redirect_to(
        admin_finance_billing_products_path,
        flash: { success: "Sync performed successfully" }
      ) and return
    rescue StandardError => error
      Errors::Reporter.notify(error, false)

      redirect_to(
        admin_finance_billing_products_path,
        flash: { error: "Something went wrong, contact dev" }
      )
    end
  end
end
