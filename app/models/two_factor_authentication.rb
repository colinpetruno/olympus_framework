class TwoFactorAuthentication < ApplicationRecord
  # TODO: Rename me to something to show the styles or types of 2fa
  include NotDeletable

  belongs_to :member

  has_one :mobile_authenticator, -> { where(deleted_at: nil) }
  has_many :webauthn_credentials

  enum auth_type: {
    fips: 0,
#    text_message: 1, # removed for now so AuditTwoFactorRecords works better
    mobile_authenticator: 2
  }
end
