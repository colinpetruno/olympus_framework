module Dashboard::Settings::Billing
  class InvoicesController < AuthenticatedController
    layout "billing"

    def show
      @invoice = ::Billing::Invoice.find_by!(number: params[:id])

      # TODO: Pundit auth
      if @invoice.invoiceable != session_info.account
        redirect_to root_path and return
      end

      @stripe_invoice = ::Stripe::Invoice.retrieve(
        @invoice.billing_external_id.external_id
      )
    end
  end
end
