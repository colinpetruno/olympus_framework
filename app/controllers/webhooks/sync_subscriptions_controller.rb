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


# HEADERS
#
# @req=
#   #<ActionDispatch::Request:0x00007fb54f2c4780
#    @env=
#     {"rack.version"=>[1, 3],
#     "rack.errors"=>#<IO:<STDERR>>,
#     "rack.multithread"=>true,
#     "rack.multiprocess"=>false,
#     "rack.run_once"=>false,
#     "SCRIPT_NAME"=>"",
#     "QUERY_STRING"=>"",
#     "SERVER_PROTOCOL"=>"HTTP/1.1",
#     "SERVER_SOFTWARE"=>"puma 4.3.5 Mysterious Traveller",
#     "GATEWAY_INTERFACE"=>"CGI/1.2",
#     "HTTPS"=>"https",
#     "REQUEST_METHOD"=>"POST",
#     "REQUEST_PATH"=>"/webhooks/sync_subscriptions/5a75a837-e1ea-460f-a525-90a8eb58fef9",
#     "REQUEST_URI"=>"/webhooks/sync_subscriptions/5a75a837-e1ea-460f-a525-90a8eb58fef9",
##     "HTTP_VERSION"=>"HTTP/1.1",
#     "HTTP_HOST"=>"development.meettrics.com",
#     "HTTP_ACCEPT"=>"*/*",
#     "HTTP_X_GOOG_CHANNEL_ID"=>"5a75a837-e1ea-460f-a525-90a8eb58fef9",
#     "HTTP_X_GOOG_CHANNEL_EXPIRATION"=>"Sat, 04 Jul 2020 06:23:53 GMT",
#     "HTTP_X_GOOG_RESOURCE_STATE"=>"exists",
#     "HTTP_X_GOOG_MESSAGE_NUMBER"=>"4556187",
#      "HTTP_X_GOOG_RESOURCE_ID"=>"alzQL4DDSvIZQV0dMZHm7pBimL8",
# Results=250&singleEvents=true&alt=json",
#      "HTTP_CONNECTION"=>"keep-alive",
#      "HTTP_USER_AGENT"=>"APIs-Google; (+https://developers.google.com/webmasters/APIs-Google.html)",
#      "HTTP_ACCEPT_ENCODING"=>"gzip,deflate,br",
#      "CONTENT_LENGTH"=>"0",
#      "puma.request_body_wait"=>0,
#      "SERVER_NAME"=>"development.meettrics.com",
#      "SERVER_PORT"=>"443",
#      "PATH_INFO"=>"/webhooks/sync_subscriptions/5a75a837-e1ea-460f-a525-90a8eb58fef9",
#      "REMOTE_ADDR"=>"::1",
