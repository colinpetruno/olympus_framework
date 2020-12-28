class SupportMailer < ApplicationMailer
  def new_support_request(support_request)
    @support_request = support_request
    mail(to: "support@meettrics.com")
  end
end
