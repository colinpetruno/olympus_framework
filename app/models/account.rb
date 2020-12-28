class Account < ApplicationRecord
  has_one :company

  has_many :billing_sources, as: :sourceable, class_name: "Billing::Source"
  has_many :billing_details, as: :detailable, class_name: "Billing::Detail"
  has_one :primary_billing_detail, as: :detailable, class_name: "Billing::Detail"
end
