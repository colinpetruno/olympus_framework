class AuthCredentialLog < ApplicationRecord
  encrypted_fields :token, :refresh_token

  validates :expires_at, presence: true, if: :expires?
end
