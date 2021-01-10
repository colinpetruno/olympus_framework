module Authentication::Forms
  class SignupForm
    include ActiveModel::Model

    attr_accessor :email, :password, :password_confirmation, :given_name,
                  :family_name, :member

    def self.model_name
      ActiveModel::Name.new(self, nil, "Signup")
    end

    def sign_up
      result = Accounts::Creator.for({
          member: {
            email: email.downcase,
            password: password,
            password_confirmation: password_confirmation,
            member_type: :member,
            provider: :email,
            profile_attributes: {
              email: email.downcase,
              given_name: given_name,
              family_name: family_name,
              timezone: "UTC"
            }
          },

          company: {
            email_domain: Domains::RejectList.cleaned_domain(
              email.downcase.split("@").last
            ),
            name: I18n.t("defaults.application.company_name"),
            auth_credential_id: nil,
            open_signups: :disabled,
            provider: "email"
          }
        })

      if result[:member].persisted?
        @member = result[:member]

        return true
      else
        # Note: this shouldn't get hit.. just a safety measure instead of
        # trying to continue if something does go wrong in the future
        raise StandardError.new("Something went wrong enrolling the member")
      end
    end
  end
end
