module Ichnaea
  class TrackPageviewJob < ApplicationJob
    def perform(session_id = nil, userable_id = nil, userable_type = nil, event_json)
      event_json = JSON.parse(event_json)
      @ichnaea_user = nil
      referrer_url = nil

      if userable_id.present? && userable_type.present?
        @ichnaea_user = Ichnaea::User.find_or_create_by!(
          userable_id: userable_id,
          userable_type: userable_type
        )
      end

      if event_json["request_information"]["referrer"].present?
        referring_uri = URI::Parser.new.parse(
          event_json["request_information"]["referrer"]
        )

        referrer_url = ::Ichnaea::Url.find_or_create_by(
          url_hash: ::Ichnaea::Hasher.for_uri(referring_uri)
        ) do |url|
          url.domain = referring_uri.hostname
          url.path = referring_uri.path
        end
      end

      uri = URI::Parser.new.parse(
        event_json["request_information"]["url"]
      )

      url = ::Ichnaea::Url.find_or_create_by(
        url_hash: ::Ichnaea::Hasher.for_uri(uri)
      ) do |url|
        url.domain = uri.hostname
        url.path = uri.path
      end

      query_parameters = event_json["request_information"]["query_parameters"]

      utms_hash = ::Ichnaea::SanitizedParams.utms(query_parameters)

      utm = ::Ichnaea::Utm.find_or_create_by(
        utms_hash
      ) do |utm|
        utm.utm_source = query_parameters["utm_source"]
        utm.utm_medium = query_parameters["utm_medium"]
        utm.utm_campaign = query_parameters["utm_campaign"]
        utm.utm_term = query_parameters["utm_term"]
        utm.utm_content = query_parameters["utm_content"]
      end

      user_agent = Ichnaea::UserAgent.find_or_create_by(
        user_agent: event_json["request_information"]["user_agent"]
      )

      ip = Ichnaea::Ip.find_or_create_by(
        ip_hash: Ichnaea::Hasher.for(event_json["request_information"]["ip"])
      ) do |ip|
        ip.ip_address = event_json["request_information"]["ip"]
      end

      cleaned_params = Ichnaea::SanitizedParams.for(
        event_json["event_payload"]
      )
      hashed_payload = ::Ichnaea::Hasher.for_hash(cleaned_params)

      payload = Ichnaea::Payload.find_or_create_by(
        payload_hash: hashed_payload
      ) do |payload|
        payload.payload = cleaned_params
      end

      Ichnaea::PageView.create!(
        viewed_by_id: @ichnaea_user&.id,
        ichnaea_urls_id: url.id,
        ichnaea_referrers_id: referrer_url&.id,
        ichnaea_utms_id: utm.id,
        ichnaea_user_agents_id: user_agent.id,
        ichnaea_ips_id: ip.id,
        ichnaea_query_strings_id: payload.id,
        viewed_at: DateTime.parse(event_json["viewed_at"])
      )

      tracker = Mixpanel::Tracker.new(
        Rails.application.credentials.mixpanel_token
      )

      browser = Browser.new(event_json["request_information"]["user_agent"])

      tracker.track(
        @ichnaea_user&.id || session_id,
        "Page View",
        cleaned_params.merge({
          ip: ::Ichnaea::IpMasker.mask(event_json["request_information"]["ip"]),
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
