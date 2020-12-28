if Rails.env.production?
  ActionMailer::Base.smtp_settings = {
    domain: "www.meettrics.com",
    address: "smtp.sendgrid.net",
    port: 587,
    authentication: :plain,
    user_name: "apikey",
    password: Rails.application.credentials.sendgrid_api_key
  }
end
