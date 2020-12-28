module Billing::Webhooks
  module Events
    MAP = {
      "charge.succeeded": Billing::Webhooks::Events::ChargeSucceeded,
      "charge.captured": Billing::Webhooks::Events::ChargeCaptured,

      "invoice.created": Billing::Webhooks::Events::InvoiceCreatedOrUpdated,
      "invoice.updated": Billing::Webhooks::Events::InvoiceCreatedOrUpdated,
      "invoice.finalized": Billing::Webhooks::Events::InvoiceCreatedOrUpdated,
      "invoice.paid": Billing::Webhooks::Events::InvoiceCreatedOrUpdated,
      "invoice.payment_succeeded": Billing::Webhooks::Events::InvoiceCreatedOrUpdated,

      "price.created": Billing::Webhooks::Events::PriceCreated,
      "price.updated": Billing::Webhooks::Events::PriceCreated,
      "price.deleted": Billing::Webhooks::Events::PriceDeleted,

      "product.created": Billing::Webhooks::Events::ProductCreatedOrUpdated,
      "product.updated": Billing::Webhooks::Events::ProductCreatedOrUpdated,
      "product.deleted": Billing::Webhooks::Events::ProductDeleted,

      "tax_rate.created": Billing::Webhooks::Events::TaxRateCreatedOrUpdated,
      "tax_rate.updated": Billing::Webhooks::Events::TaxRateCreatedOrUpdated
    }

    # customer.source.deleted
    # payment_method.detached
  end
end
