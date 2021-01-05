module Webhooks
  class SyncSubscriptionsController < ApplicationController
    skip_before_action :verify_authenticity_token

    def update
      begin
        subscription = SyncSubscription.find_by!(
          sync_uuid: params[:id],
          revoked_at: nil
        )
      rescue ActiveRecord::RecordNotFound => error
        Rails.logger.info("Could not find: #{params[:id]}")

        if Rails.env.development?
          # this is in development mode for the case you might reset the
          # database with outstanding subscriptions
          if request.headers["HTTP_X_GOOG_RESOURCE_ID"].present?
            puts "Unsubscribing google resource"
            # this is a google sync subscription

            begin
              ::ExternalResources::Google::Calendars::Subscriber.new(
                calendar: nil,
                session_info: Members::SessionInfo.for(Member.last)
              ).unsubscribe_by_ids(
                channel_id: request.headers["HTTP_X_GOOG_CHANNEL_ID"],
                resource_id: request.headers["HTTP_X_GOOG_RESOURCE_ID"]
              )
            rescue StandardError => error
              puts "Encountered an unsubscribe error"
              puts error.message
            end
          end
        end

        raise error
      end

      subscription.update(activated: true)

      SyncSubscriptionNotification.create(
        sync_subscription: subscription,
        company_id: subscription.company_id,
        received_at: DateTime.now
      )

      session_info = ::Members::SessionInfo.by_sync_subscription(subscription)

      Syncs::Queuer.new(session_info).queue(
        subscription.sync_base,
        subscription.subscribeable
      )

      head :ok
    end
  end
end
