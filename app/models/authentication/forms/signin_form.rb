module Authentication::Forms
  class SigninForm
    include ActiveModel::Model

    attr_accessor :email, :password

    def self.model_name
      ActiveModel::Name.new(self, nil, "Signin")
    end

    def sign_in?
      return if member.blank?

      member.valid_password?(password)
    end

    def member
      @_member ||= Member.find_by(
        hashed_email: Portunus::Hasher.for(email)
      )
    end
  end
end
