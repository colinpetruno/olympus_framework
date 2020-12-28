class ExternalProfile < ApplicationRecord
  has_many :calendar_participants, as: :participatable
  has_many :calendar_events, as: :organizable
  has_many :calendar_events, as: :creatable

  encrypted_fields :email
end
