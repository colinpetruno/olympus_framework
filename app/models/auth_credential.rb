class AuthCredential < ApplicationRecord
  encrypted_fields :account_name, :token, :refresh_token

  belongs_to :member
  has_many :broken_auth_records

  validates :expires_at, presence: true, if: :expires?

  REFRESH_BUFFER = 60.freeze

  def expired?
    (expires_at - DateTime.now.to_i) < REFRESH_BUFFER
  end
end
