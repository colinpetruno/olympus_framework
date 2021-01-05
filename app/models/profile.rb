class Profile < ApplicationRecord
  include NotDeletable

  default_scope -> { where(deleted_at: nil) }

  belongs_to :company
  belongs_to :member
  has_one :notification_preference

  validates :given_name, :family_name, presence: true
  validates :email, :hashed_email, presence: true
  validates :email, email: true
  validates :timezone, presence: true

  encrypted_fields :email, :external_slug, :given_name, :family_name, :timezone
  attr_scrubbable :email, :external_slug, :given_name, :family_name

  attr_exportable(
    :email,
    :full_name,
    :timezone,
    external_slug: {
      attr_name: :external_url,
      transform: -> (field_value) { [field_value, field_value].join(" - ") }
    }
  )

  enum role: {
    basic: 0,
    company_manager: 1,
    company_admin: 2
  }

  enum status: {
    active: 0,
    pending: 1,
    disabled: 2,
    deleted: 3
  }

  def self.active
    where("deleted_at is null")
  end

  def self.role_collection_options
    roles.map do |key, value|
      [I18n.t("models.defaults.profile.roles.#{key.to_s}"), key]
    end
  end

  def full_name
    # NOTE: This weird thing is a no break space. It prevents the name from
    # wrapping lines and treats the name as one word.
    [given_name, family_name].compact.join([160].pack('U*'))
  end
end
