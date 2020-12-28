module Ichnaea
  class TrackEventJob < ApplicationJob
    queue_as :ichnaea

    def perform(session_id = nil, trackable_id = nil, trackable_type = nil, event_json)
      parsed_json = JSON.parse(event_json)
      event_name = parsed_json["event_name"]
      payload = parsed_json["event_payload"]
      url = parsed_json["url"]
      occured_at = DateTime.parse(parsed_json["event_time"])
      ichnaea_url = nil

      if url.present?
        uri = URI::Parser.new.parse(url)

        ichnaea_url = ::Ichnaea::Url.find_or_create_by(
          url_hash: ::Ichnaea::Hasher.for_uri(uri)
        ) do |url|
          url.domain = uri.hostname
          url.path = uri.path
        end
      end

      ichnaea_user = nil

      if trackable_id.present? && trackable_type.present?
        ichnaea_user = Ichnaea::User.find_or_create_by!(
          userable_id: trackable_id,
          userable_type: trackable_type
        )
      end

      event_type = ::Ichnaea::EventType.find_or_create_by(
        name: event_name
      )

      payload_hash = Ichnaea::Hasher.for_hash(payload)

      ich_payload = ::Ichnaea::Payload.find_or_create_by(
        payload_hash: payload_hash
      ) do |i_payload|
        i_payload.payload = payload
      end

      ::Ichnaea::Event.create(
        ichnaea_event_type_id: event_type.id,
        event_time: occured_at,
        ichnaea_event_payload_id: ich_payload.id,
        performed_by_id: ichnaea_user&.id,
        ichnaea_url_id: ichnaea_url&.id
      )

      browser = Browser.new(parsed_json["request_information"]["user_agent"])

      tracker = Mixpanel::Tracker.new(
        Rails.application.credentials.mixpanel_token
      )

      tracker.track(
        trackable_id || session_id,
        event_name,
        payload.merge({
          ip: ::Ichnaea::IpMasker.mask(parsed_json["request_information"]["ip"]),
          "user_agent": event_json["request_information"]["user_agent"],
          "$browser": browser.name,
          "$browser_version": browser.full_version,
          "$device": browser.device.name,
          "$os": browser.platform.name
        })
      )
    end
  end
end
