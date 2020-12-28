class Company < ApplicationRecord
  belongs_to :account

  has_one :auth_credential
  has_many :calendars
  has_many :event_participants
  has_many :profiles
  has_many :sync_subscriptions
  has_many :teams

  has_one :billing_detail, class_name: "::Billing::Detail"
  accepts_nested_attributes_for :billing_detail

  validates :name, :hashed_name, :email_domain, :hashed_email_domain, presence: true

  encrypted_fields :name, :email_domain
  attr_exportable :name, :email_domain
  attr_scrubbable :hashed_email_domain, :name, :email_domain

  enum open_signups: {
    allowed: 0,
    invite: 1,
    disabled: 2
  }

  def self.open_signup_options
    self.open_signups.map do |key, value|
      [key.capitalize, key]
    end
  end

  def account
    # TODO: See above, this is just a lazy backfill
    if account_id.blank?
      create_account!
    else
      super
    end
  end
end
