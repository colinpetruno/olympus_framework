class MailTemplate < ApplicationRecord
  validates :method_name, presence: true
  validates :class_name, presence: true
  validates :content, presence: true
  validates :subject, presence: true

  def to_html
    template = Redcarpet::Render::HTML.new(prettify: true)
    markdown = Redcarpet::Markdown.new(template)
    markdown.render(self.content)
  end
end
