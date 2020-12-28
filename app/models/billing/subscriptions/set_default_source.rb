module Billing::Subscriptions
  class SetDefaultSource
    def self.for(session_info, source)
      new(session_info, source).make_default
    end

    def initialize(session_info, source)
      @session_info = session_info
      @source = source
    end

    def make_default
      ::Stripe::Customer.update(
        stripe_customer.billing_external_id.external_id,
        {
          invoice_settings: {
            default_payment_method: source_external_id
          }
        }
      )
    end

    private

    attr_reader :source, :session_info

    def source_external_id
      source.billing_external_id.external_id
    end

    def stripe_customer
      ::Billing::CustomerFinder.for(session_info)
    end
  end
end
