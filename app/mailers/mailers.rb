# frozen_string_literal: true

# Mail to get template from table
class Mailers
  def self.load(klass, method_name)
    MailTemplate.where(class_name: klass.to_s, method_name: method_name).first
  end
end
