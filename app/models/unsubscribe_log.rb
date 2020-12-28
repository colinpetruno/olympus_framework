class UnsubscribeLog < ApplicationRecord
  belongs_to :profile

  enum action: {
    subscribe: 0,
    unsubscribe: 1
  }
end
