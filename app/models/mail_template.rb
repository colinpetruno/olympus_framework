class MailTemplate < ApplicationRecord
  validates :method_name, presence: true
  validates :class_name, presence: true
  validates :content, presence: true
  validates :subject, presence: true
end
