class BetaRequest < ApplicationRecord
  encrypted_fields :email

  attr_scrubbable :email
end
