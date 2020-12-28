module Billing::Stripe
  class ProcessWebhookJob < ApplicationJob
    queue_as :billing

    SKIP_WEBHOOKS = [
      "customer.created",
      "customer.updated",
      "customer.source.created",
      "customer.subscription.created",
      "customer.subscription.updated",

      "invoice_item.created",

      "payment_method.attached",

      "plan.created",
      "plan.updated",
      "plan.deleted",

      # NOTE: we skip these because we rely on the charge and invoice webhooks.
      # payment intent is between them so we either add the invoice then the
      # intent or the intent then the charge.
      "payment_intent.created",
      "payment_intent.succeeded",

      "setup_intent.created",
      "source.chargeable",
    ]

    # 431 test with
    def perform(webhook_id)
      @webhook = ::Billing::Webhook.find(webhook_id)

      @webhook.update(process_status: :processing, processed_at: DateTime.now)

      @event = Stripe::Event.construct_from(
        JSON.parse(@webhook.payload, symbolize_names: true)
      )

      @processor = Billing::Webhooks::Events::MAP[@event.type.to_sym]

      if SKIP_WEBHOOKS.include?(@event.type)
        @webhook.update(process_status: :skipped)
      elsif @processor.present?
        @processor.process(@event)
        @webhook.update(process_status: :succeeded)
      else
        @webhook.update(process_status: :not_implemented)

        begin
          # If we don't want to skip the processing then raise an error to show
          # there is an unsupported / unexpected webhook
          Errors::Reporter.notify(
            StandardError.new("Unsupported webhook type for #{@event.type}"),
            false
          )
        end
      end
    rescue StandardError => error
      ::Errors::Reporter.notify(error)

      @webhook.update(
        process_status: :failed,
        process_result: error.message + error.backtrace.join("\n")
      )
    end
  end
end

