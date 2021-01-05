module Dashboard::Settings
  class BillingsController < AuthenticatedController
    layout "art_pane/billing"

    def index
      @current_plan = ::Billing::Subscription.find_by(
        active: true,
        ownerable: session_info.account
      )

      @plans = ::Billing::PlansWithPrices.collect

      @sources = ::Billing::Source.where(
        sourceable: session_info.account,
        deleted_at: nil
      ).order([:exp_year, :exp_month])

      @invoices = ::Billing::Invoice.where(
        invoiceable: session_info.account
      ).order(created_at: :desc)
    end
  end
end
