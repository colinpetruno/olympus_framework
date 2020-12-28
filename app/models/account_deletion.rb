class AccountDeletion < ApplicationRecord
  belongs_to :company
  belongs_to :profile
end
