module Billing
  class ExternalId < ApplicationRecord
    belongs_to :objectable, polymorphic: true
  end
end
