class Ichnaea::User < ApplicationRecord
  belongs_to :userable, polymorphic: true
  has_many(
    :events,
    class_name: "Ichnaea::Event",
    foreign_key: :performed_by_id
  )

  has_many(
    :page_views,
    class_name: "Ichnaea::PageView",
    foreign_key: :viewed_by_id
  )
end
