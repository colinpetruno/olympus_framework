class Member < ApplicationRecord
  include NotDeletable
  include Uuidable

  devise :registerable, :rememberable, :validatable, :trackable

  # NOTE: This association is explicit to this app since a login email can
  # only get tied to one company. Destroy it if a member can belong to
  # multiple companies (like the Stripe dashboard).
  belongs_to :company

  # TODO: Fix this duplication. It does work suprisingly but we need to get
  # rid of the has_one in favor of the has_many
  has_many :auth_credentials
  has_one :auth_credential

  has_many :sync_logs
  has_one :member_billing_detail
  has_one :profile

  # These are used for devise to function but not used for the application
  # itself right now.
  attr_accessor :password, :password_confirmation

  validates :email, :hashed_email, presence: true
  validates :email, email: true
  validates :hashed_email, uniqueness: true

  accepts_nested_attributes_for :profile

  encrypted_fields :email
  attr_scrubbable :hashed_email, :email

  # We could get rid of this using finders but we need to first figure out
  # how to ensure devise does not find deleted members
  default_scope { where(deleted_at: nil) }

  enum member_type: {
    member: 0,
    application_admin: 1
  }

  enum provider: {
    google_oauth2: 0,
    password: 1
  }

  def password_required?
    false
  end
end
