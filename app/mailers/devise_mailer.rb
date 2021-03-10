# frozen_string_literal: true

# DeviseMaielr for sending devise mails
class DeviseMailer < Devise::Mailer
  helper :application
  include Devise::Controllers::UrlHelpers
  include ActionView::Helpers::UrlHelper

  def devise_mail(record, action, options = {}, &block)
    initialize_from_record(record)
    @context = binding
    @mail_template = Mailers.load('Devise::Mailer', action)
    headers = headers_for(action, {})
    template_view = 'mail_templates/show.html.erb'
    headers[:subject] = 'This is test email'
    mail headers do |format|
      format.html do
        render template_view
      end
    end
  end
end
