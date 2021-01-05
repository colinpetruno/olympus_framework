module Authentication
  class ConfirmationsController < ApplicationController
    layout "art_pane"

    def index
      # NOTE: Handling a refresh on a page that renders via a post.
      redirect_to new_auth_confirmation_path
    end

    def new
      @member = nil

      if params[:confirmation_token].present?
        @member = Member.find_by(
          confirmation_token: params[:confirmation_token]
        )
      end

      if @member.present?
        ::Authentication::Members.confirm(@member)
      end

      @form = Authentication::Forms::ResendConfirmationForm.new(
        email: @member&.email
      )
    end

    def create
      @email = confirmation_params[:email]
      @member = Member.find_by(email: @email) if @email.present?

      if @member.present?
        @member.resend_confirmation_instructions
      end
    end

    private

    def confirmation_params
      params.require(:confirmation).permit(:email)
    end
  end
end
