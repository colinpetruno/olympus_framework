class SupportRequest < ApplicationRecord
  include NotDeletable
  include Uuidable

  belongs_to :company, optional: true
  belongs_to :profile, optional: true
  belongs_to :resolvable, polymorphic: true, optional: true
  belongs_to :supportable, polymorphic: true

  has_many :support_request_messages, -> { order("created_at ASC") }

  accepts_nested_attributes_for :support_request_messages

  def to_param
    uuid
  end
end
