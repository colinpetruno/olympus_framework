module Billing::Stripe
  class VatRateUpserter
    def self.for(stripe_vat)
      new(stripe_vat).upsert
    end

    def initialize(stripe_vat)
      @stripe_vat = stripe_vat
    end

    def upsert
      objectable = nil

      external_id = ::Billing::ExternalId.find_by(
        external_id: stripe_vat.id
      )

      if external_id.blank?
        ApplicationRecord.transaction do
          objectable = ::Billing::VatRate.create!(
            active: stripe_vat.active,
            display_name: stripe_vat.description,
            jurisdiction: stripe_vat.jurisdiction,
            inclusive_type: inclusive_type,
            percentage: stripe_vat.percentage,
            default_rate: default?
          )

          ::Billing::ExternalId.create!(
            objectable: objectable,
            external_id: stripe_vat.id
          )
        end
      else
        objectable = external_id.objectable

        objectable.update(
          active: stripe_vat.active,
          display_name: stripe_vat.description,
          jurisdiction: stripe_vat.jurisdiction,
          inclusive_type: inclusive_type,
          percentage: stripe_vat.percentage,
          default_rate: default?
        )
      end

      return objectable
    end

    private

    attr_reader :stripe_vat

    def default?
      starting_number_of_vat_rates == 0
    end

    def inclusive_type
      if stripe_vat.inclusive == true
        :inclusive
      else
        :exclusive
      end
    end

    def starting_number_of_vat_rates
      ::Billing::VatRate.all.size
    end
  end
end
