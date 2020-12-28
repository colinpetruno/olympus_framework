module Styleguide
  class DemoFormModel
    include ActiveModel::Model

    attr_accessor :field_one, :field_two, :field_three, :field_four,
                  :field_five, :field_six, :field_seven, :field_eight,
                  :field_nine, :field_ten, :field_eleven, :field_twelve,
                  :field_thirteen, :field_fourteen, :field_fifteen,

                  :checkbox_field, :email_field, :file_field, :number_field,
                  :password_field, :radio_field, :range_field, :search_field,
                  :select_field, :standard_field, :telephone_field,
                  :text_field, :url_field

    def initialize
      errors.add(:email_field, "Wrong email format")
    end
  end
end
