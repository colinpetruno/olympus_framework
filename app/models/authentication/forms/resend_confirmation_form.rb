module Authentication::Forms
  class ResendConfirmationForm
    include ActiveModel::Model

    attr_accessor :email

    def self.model_name
      ActiveModel::Name.new(self, nil, "Confirmation")
    end
  end
end

