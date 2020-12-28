class BrokenAuthRecord < ApplicationRecord
  belongs_to :auth_credential
  belongs_to :member

  enum provider: {
    google_oauth2: 0
  }
end
