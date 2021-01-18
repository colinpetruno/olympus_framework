module EmailValidatable
  extend ActiveSupport::Concern

  class EmailValidator < ActiveModel::EachValidator
    def validate_each(record, attr, value)
      if !value.match?(URI::MailTo::EMAIL_REGEXP)
        record.errors[attr] << (options[:message] || "is not an email")
      end

      begin
        a = Mail::Address.new(value)
        record.send("#{attr}=".to_sym, a.address)
      rescue Mail::Field::ParseError
        record.errors[attr] << (options[:message] || "is not an email")
      end
    end
  end
end
