module Admin::Forms
  class EnrollmentForm
    include ActiveModel::Model

    attr_accessor :email, :password, :password_confirmation, :invitation_token,
                  :given_name, :family_name, :member

    validates(
      :email, :password, :password_confirmation, :given_name, :family_name,
      presence: true
    )

    def self.model_name
      ActiveModel::Name.new(self, nil, "Enrollment")
    end

    def enroll
      if invitation_token.present?
        enroll_by_token
      else
        enroll_new_admin
      end
    end

    private

    def enroll_by_token
      # // look up invite company and add an admin to that
    end

    def existing_admin_count
      Member.where(member_type: :application_admin).size
    end

    def enroll_new_admin
      return if existing_admin_count > 0

      result = Accounts::Creator.for({
          member: {
            email: email.downcase,
            password: password,
            password_confirmation: password_confirmation,
            member_type: :application_admin,
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
        # Tell the app we made an admin so the check continues
        Olympus.settings.admin_created!
        @member = result[:member]

        return true
      else
        # Note: this shouldn't get hit.. just a safety measure instead of
        # trying to continue if something does go wrong in the future
        raise StandardError.new("Something went wrong enrolling the admin")
      end
    end
  end
end
