module Authentication::Forms
  class PasswordResetForm
    include ActiveModel::Model

    attr_accessor :email, :password, :password_confirmation

    validate :password_match

    def self.model_name
      ActiveModel::Name.new(self, nil, "PasswordReset")
    end

    def send_reset_notification
      return false if member.blank?

      member.send_reset_password_instructions

      return true
    rescue StandardError => error
      Errors::Reporter.notify(error)

      return false
    end

    def update_password
      member.update(
        password: password,
        password_confirmation: password_confirmation
      )

      member.errors.blank?
    end

    private

    def member
      Member.find_by(hashed_email: Portunus::Hasher.for(email))
    end

    def password_match
      return false if password.blank? || password_confirmation.blank?

      if password != password_confirmation
        errors.add(:password, "The passwords must match")
      end
    end
  end
end
