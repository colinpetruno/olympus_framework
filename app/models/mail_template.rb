# frozen_string_literal: true

# model for mail template create in db and convert from markdown
class MailTemplate < ApplicationRecord
  validates :method_name, presence: true
  validates :class_name, presence: true
  validates :content, presence: true
  validates :subject, presence: true

  def to_html(context)
    template = ERB.new content
    template_result = template.result(context)
    document = Redcarpet::Render::HTML.new(prettify: true)
    markdown = Redcarpet::Markdown.new(document)
    markdown.render(template_result)
  end
end
