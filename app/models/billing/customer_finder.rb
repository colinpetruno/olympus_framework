module Billing
  class CustomerFinder
    def self.for(session_info)
      new(session_info).find
    end

    def initialize(session_info)
      @session_info = session_info
    end

    def find
      customer || create_customer
    end

    private

    attr_reader :session_info

    def create_customer
      created_customer = nil
      created_stripe_customer = stripe_customer

      ApplicationRecord.transaction do
        created_customer = ::Billing::Customer.create!(
          customerable: session_info.account,
          provider: :stripe,
          external_id: stripe_customer.id
        )

        ::Billing::ExternalId.create(
          objectable: customer,
          external_id: created_stripe_customer.id
        )
      end

      return created_customer
    end

    def stripe_customer
      @_stripe_customer ||= ::Stripe::Customer.create({
        email: session_info.member.email,
        name: session_info.company.name,
        metadata: {
          application_customer_id: session_info.account.id,
          application_customer_type: session_info.account.class.name
        }
      })
    end

    def customer
      ::Billing::Customer.find_by(
        customerable: session_info.account
      )
    end
  end
end
