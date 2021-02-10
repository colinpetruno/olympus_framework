# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MailTemplate, type: :model do
  it 'is in_valid with out attributes' do
    expect(MailTemplate.new).not_to be_valid
  end
  it { should validate_presence_of(:class_name) }
  it { should validate_presence_of(:method_name) }
  it { should validate_presence_of(:content) }
  it { should validate_presence_of(:subject) }

  it 'should be valid with all values' do
    mail_template = MailTemplate.new(subject: 'subject of email',
                                     content: 'Content of email',
                                     method_name: 'method_name',
                                     class_name: 'class_name')
    expect(mail_template).to be_valid
  end
end
