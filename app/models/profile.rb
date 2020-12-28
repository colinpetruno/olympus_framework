class Profile < ApplicationRecord
  include NotDeletable

  default_scope -> { where(deleted_at: nil) }

  belongs_to :company
  belongs_to :member
  belongs_to :team
  has_many :calendars
  has_many :calendar_events
  has_many :event_participants, as: :participatable
  has_many :meeting_templates
  has_one :notification_preference
  has_one :schedule_setting

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
    :team_id,
    external_slug: {
      attr_name: :external_url,
      transform: -> (field_value) { [field_value, field_value].join(" - ") }
    }
  )

  enum role: {
    basic: 0,
    team_manager: 1,
    company_manager: 2,
    company_admin: 3
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

  private
end
