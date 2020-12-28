module Webhooks
  class StripesController < ApplicationController
    skip_before_action :verify_authenticity_token

    def create
      payload_json = request.body.read

      webhook = ::Billing::Webhook.create(
        provider: :stripe,
        processed_at: nil,
        process_status: :pending,
        process_result: nil,
        payload: payload_json
      )

      begin
        ::Billing::Stripe::ProcessWebhookJob.new.perform(webhook.id)
      rescue StandardError => error
        webhook.update(status: :failed)
        Errors::Reporter.notify(error)
      end

      head :ok
    end
  end
end
