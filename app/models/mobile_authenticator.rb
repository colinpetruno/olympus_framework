class MobileAuthenticator < ApplicationRecord
  include NotDeletable

  belongs_to :two_factor_authentication

  encrypted_fields :otp_base

  attr_reader :otp_password
end
