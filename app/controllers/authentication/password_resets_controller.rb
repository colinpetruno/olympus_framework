module Authentication
  class PasswordResetsController < ApplicationController
    layout "art_pane/authentication"

    def index
      redirect_to new_auth_password_reset_path
    end

    def new
      @form = ::Authentication::Forms::PasswordResetForm.new
    end

    def create
      @form = ::Authentication::Forms::PasswordResetForm.new(
        password_reset_params
      )

      @notification_sent = @form.send_reset_notification
    end

    def edit
      @member = Member.with_reset_password_token(params[:id])

      if @member.present?
        @form = ::Authentication::Forms::PasswordResetForm.new(
          email: @member.email
        )
      end
    end

    def update
      @member = Member.with_reset_password_token(params[:id])

      @form = ::Authentication::Forms::PasswordResetForm.new(
        password_reset_params.merge(email: @member.email)
      )

      if @form.valid? && @form.update_password
        # NOTE: reload is important since the password update uses a different
        # intance of member, refresh the member instance after the reset so
        # it functions properly
        sign_in(@member.reload)

        redirect_to(
          dashboard_root_path,
          flash: { success: "Your password has been updated" }
        ) and return
      else
        render :edit
      end
    end

    private

    def password_reset_params
      params.
        require(:password_reset).
        permit(:email, :password, :password_confirmation)
    end
  end
end
