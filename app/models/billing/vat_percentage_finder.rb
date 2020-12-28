module Billing
  class VatPercentageFinder
    def self.for(payment_intent)
      new(payment_intent).find
    end

    def initialize(payment_intent)
      @payment_intent = payment_intent
    end

    def find
      return 0 if company_id.blank?

      address = ::Address.where(company_id: company_id).order(:updated_at).last

      return 0 if address.blank?

      ::Billing::VatRate.find_by(jurisdiction: jurisdiction(address))&.percentage || 0
    end

    private

    attr_reader :payment_intent

    def jurisdiction(address)
      # COUNTRY-PROVINCE
      # NL
      # US-PA

      # TODO: Clean this part up so it better adjusts directly from the
      # payment_intents selected source / company preferences. If pulling from
      # a source we would need to add an ajax request when choosing a different
      # card. Cards added here also don't have billing details so we need to
      # fix that as well.

      if address.country_code == "US"
        ["US", address.province].map(&:upcase).join("-")
      else
        address.country_code
      end
    end

    def company_id
      payment_intent.billable.company.id
    end
  end
end
