# Preview all emails at http://localhost:3000/rails/mailers/support_mailer
class SupportMailerPreview < ActionMailer::Preview
  def new_support_request
    support_request = SupportRequest.last

    if support_request.blank?
      contact_request = ContactUsRequest.create(
        category: :technical,
        email: "testperson@example.com",
        request: "Hey can you help me here",
        submitted_at: DateTime.now
      )

      support_request = SupportRequest.create(
        company: nil,
        profile: nil,
        supportable: contact_request,
        submitted_at: DateTime.now
      )
    end

    # SupportMailer.with(user: User.first).welcome_email
    SupportMailer.new_support_request(support_request)
  end
end
