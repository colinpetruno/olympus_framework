module ExternalResources::Google::Calendars
  class Subscriber < ExternalResources::Google::Calendars::Base
    def initialize(session_info:, calendar:)
      @calendar = calendar
      @session_info = session_info
    end

    def subscribe
      return if subscribed?

      create_sync_subscription

      result = connection.watch_event(
        calendar.external_id,
        Google::Apis::CalendarV3::Channel.new(
          address: webhook_url,
          id: subscription_uuid,
          type: "web_hook"
        ),
        single_events: true
      )

      sync_subscription.update(
        expires_at: DateTime.strptime((result.expiration / 1000).to_s, "%s"),
        external_id: result.resource_id,
        sync_uuid: result.id
      )
    end

    def unsubscribe
      channel = Google::Apis::CalendarV3::Channel.new(
        address: webhook_url,
        id: sync_subscription.sync_uuid, # the id we give it
        resource_id: sync_subscription.external_id, # the id of the channel??
        type: "web_hook"
      )

      result = connection.stop_channel(channel)

      if result.is_a?(String)
        sync_subscription.update(revoked_at: DateTime.now)
      end
    end

    def unsubscribe_by_ids(channel_id:, resource_id:)
      # primarily used to keep missing sync subscription in development in
      # check. In production this code should rarely / never be hit
      channel = Google::Apis::CalendarV3::Channel.new(
        address: webhook_url_with_id(channel_id),
        id: channel_id, # the id we give it
        resource_id: resource_id, # the id of the channel??
        type: "web_hook"
      )

      result = connection.stop_channel(channel)

      if result.is_a?(String)
        Rails.logger.info("Revoked subscription: #{channel_id}")
      end
    end

    private

    attr_reader :calendar

    def subscribed?
      sync_subscription.present?
    end

    def webhook_url_with_id(channel_id)
      if Rails.env.development?
        "https://development.meettrics.com/webhooks/sync_subscriptions/#{channel_id}"
      else
        raise StandardError.new("configure me later")
      end
    end


    def webhook_url
      if Rails.env.development?
        "https://development.meettrics.com/webhooks/sync_subscriptions/#{subscription_uuid}"
      else
        raise StandardError.new("configure me later")
      end
    end

    def sync_subscription
      @_sync_subscription ||= lookup_sync_subscription
    end

    def lookup_sync_subscription
      ::SyncSubscription.
        where("revoked_at is null").
        where(subscribeable: calendar)
    end

    def create_sync_subscription
      # The expiration date is being set to now. After the subscription is
      # created, Google will call the url in the address with the success
      # notification. Then our callback may come in first and fill out the
      # rest of the data.
      @_sync_subscription ||= SyncSubscription.find_or_create_by(
        subscribeable: calendar,
        company_id: session_info.company.id,
        revoked_at: nil
      ) do |sync|
        sync.expires_at = DateTime.now
        sync.sync_base = Syncs::CalendarEventsSync.name
        sync.sync_uuid = subscription_uuid
      end
    end

    def subscription_uuid
      @_subscription_uuid ||= SecureRandom.uuid
    end
  end
end

# def stop_channel(channel_object = nil, fields: nil, quota_user: nil,
#   user_ip: nil, options: nil, &block )
#
#
#
#      # DateTime.strptime(preview_date ,"%s")
      # 1588228226 (valid date) the 3 extra 0s are too much
      #<Google::Apis::CalendarV3::Channel:0x00007f80ea920500
      # @expiration=1588805695000, @id="100", @kind="api#channel",
      # @resource_id="R2zLFp-GA0pmc233pIY_s7dW4tc",
      # @resource_uri="https://www.googleapis.com/calendar/v3/calendars/meettrics.com_6l17c4c8sgr5oj5k3ic430t2t0@group.calendar.google.com/events?maxResults=250&singleEvents=true&alt=json">
