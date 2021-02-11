class Mailers
  def self.load(klass, method_name)
    mail_template = MailTemplate.where(class_name: klass.to_s, method_name: method_name).first
    mail_template
  end
end
