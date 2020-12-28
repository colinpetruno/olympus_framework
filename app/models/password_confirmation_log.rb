class PasswordConfirmationLog < ApplicationRecord
  include NotDeletable

  belongs_to :member

  encrypted_fields :ip_address
end
