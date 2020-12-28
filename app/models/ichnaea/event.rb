module Ichnaea
  class Event < ApplicationRecord
    has_one :event_payload
  end
end
