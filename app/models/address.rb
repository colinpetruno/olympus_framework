class Address < ApplicationRecord
  belongs_to :company

  encrypted_fields :line_1, :line_2, :city, :province, :postalcode
end
