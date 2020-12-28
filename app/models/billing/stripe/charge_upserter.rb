module Billing::Stripe
  class ChargeUpserter
    def self.for(stripe_charge, payment_intent=nil)
      new(stripe_charge, payment_intent).upsert
    end

    def initialize(stripe_charge, payment_intent=nil)
      # NOTE: Payment intent is given on the first charge insert only
      # we do not need it for updates
      @stripe_charge = stripe_charge
      @payment_intent = payment_intent
    end

    def upsert
      objectable = nil

      external_id = ::Billing::ExternalId.find_by(
        external_id: stripe_charge.id
      )

      if external_id.blank?
        ApplicationRecord.transaction do
          # the invoice is the root model of the payments, thus it will need
          # added first to tie any charge to if it doesn't exist already
          if application_invoice.blank?
            @_application_invoice = ::Billing::Invoice.create!(
              amount_due: stripe_invoice.amount_due,
              amount_paid: stripe_invoice.amount_paid,
              amount_remaining: stripe_invoice.amount_remaining,
              currency_code: stripe_invoice.currency.upcase,
              status: stripe_invoice.status,
              subtotal: stripe_invoice.subtotal,
              tax: stripe_invoice.tax || 0,
              total: stripe_invoice.total,
              invoiceable: payment_intent.chargeable,
              number: stripe_invoice.number,
              billing_external_id_attributes: {
                external_id: stripe_invoice.id
              }
            )
          end

          objectable = ::Billing::Charge.create!(
            billing_payment_intent: payment_intent,
            billing_invoice: application_invoice,
            billing_source: Billing::ExternalId.find_by!(
              external_id: stripe_charge.payment_method
            ).objectable,
            amount: stripe_charge.amount,
            refund_amount: stripe_charge.amount_refunded,
            currency: stripe_charge.currency,
            status: stripe_charge.status,
            captured: stripe_charge.captured
          )

          ::Billing::ExternalId.create!(
            objectable: objectable,
            external_id: stripe_charge.id
          )
        end
      else
        objectable = external_id.objectable

        objectable.update(
          refund_amount: stripe_charge.amount_refunded,
          status: stripe_charge.status,
          captured: stripe_charge.captured
        )
      end

      return objectable
    end

    private

    attr_reader :stripe_charge, :payment_intent

    def application_invoice
      @_application_invoice ||= ::Billing::ExternalId.
        find_by(external_id: stripe_charge.invoice)&.
        objectable
    end

    def stripe_invoice
      @_stripe_invoice ||= ::Stripe::Invoice.retrieve(stripe_charge.invoice)
    end
  end
end
