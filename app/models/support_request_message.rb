class SupportRequestMessage < ApplicationRecord
  include NotDeletable

  belongs_to :support_request
  # Person who sent the message
  belongs_to :sendable, polymorphic: true

  encrypted_fields :message

  def truncated_title
    message.truncate(60, omission: "...")
  end
end
