class WebauthnCredential < ApplicationRecord
  belongs_to :two_factor_authentication

  encrypted_fields :nickname
end
