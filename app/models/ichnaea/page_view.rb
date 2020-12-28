module Ichnaea
  class PageView < ApplicationRecord
    belongs_to(
      :ip,
      class_name: "Ichnaea::Ip",
      foreign_key: :ichnaea_ips_id
    )

    belongs_to(
      :referer,
      class_name: "Ichnaea::Referrer",
      foreign_key: :ichnaea_referrers_id,
      optional: true
    )

    belongs_to(
      :user_agent,
      class_name: "Ichnaea::UserAgent",
      foreign_key: :ichnaea_user_agents_id
    )

    belongs_to(
      :utm,
      class_name: "Ichnaea::Utm",
      foreign_key: :ichnaea_utms_id,
      optional: true
    )

    belongs_to(
      :url,
      class_name: "Ichnaea::Url",
      foreign_key: :ichnaea_urls_id
    )

  end
end
