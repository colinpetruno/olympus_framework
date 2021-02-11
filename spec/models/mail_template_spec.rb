# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MailTemplate, type: :model do
  let(:mail_template) do
    MailTemplate.new(subject: 'subject of email',
                     content: "Hello someone@gmail.com!
We're contacting you to notify you that your password has been changed.",
                     method_name: 'method_name',
                     class_name: 'class_name')
  end

  it 'is in_valid with out attributes' do
    expect(MailTemplate.new).not_to be_valid
  end
  it { should validate_presence_of(:class_name) }
  it { should validate_presence_of(:method_name) }
  it { should validate_presence_of(:content) }
  it { should validate_presence_of(:subject) }

  it 'should be valid with all values' do
    expect(mail_template).to be_valid
  end

  it 'should return proper html for markdown' do
    mail_template
    context = binding
    expect(mail_template.to_html(context)).to include('<p>Hello someone@gmail.com!')
  end
end
