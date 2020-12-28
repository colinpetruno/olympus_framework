class TwoFactorAuthLog < ApplicationRecord
  belongs_to :authenticatable, polymorphic: true
  belongs_to :member

  enum auth_status: {
    failed: 0,
    succeeded: 1
  }
end
