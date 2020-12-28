class ContactUsRequest < ApplicationRecord
  include NotDeletable

  encrypted_fields :email, :request
  attr_scrubbable :email, :request
  attr_exportable :email, :request

  validates :category, :email, :request, presence: true

  enum category: {
    technical: 0,
    billing: 1,
    request_info: 2,
    other: 3
  }

  def self.category_options
    self.categories.map do |key, value|
      [I18n.t("models.defaults.contact_us_request.categories.#{key}"), key]
    end
  end
end
