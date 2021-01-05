module Admin
  class EnrollmentsController < AdminController
    skip_before_action :enroll_admin_if_required?
    skip_before_action :authenticate_member!
    skip_before_action :ensure_active_profile
    skip_before_action :check_broken_connections!
    skip_before_action :ensure_admin
    skip_before_action :check_two_factor_auth

    layout "art_pane"

    def index
      if ::Olympus.settings.admin_created?
        raise StandardError.new("Admin was already created")
      end

      @form = ::Admin::Forms::EnrollmentForm.new
    end

    def create
      ensure_signup_permitted

      @form = ::Admin::Forms::EnrollmentForm.new(enrollment_params)

      if @form.valid? && @form.enroll
        sign_in(@form.member)

        PasswordConfirmationLog.create(
          member: @form.member,
          confirmed_at: DateTime.now,
          ip_address: request.remote_ip
        )

        session[:password_confirmation_redirect] = admin_root_path

        redirect_to(
          new_auth_two_factor_authentication_path
        )
      else
        render :index
      end
    end

    private

    def ensure_signup_permitted
      Member.where(member_type: :application_admin).size == 0
    end

    def enrollment_params
      params.
        require(:enrollment).
        permit(
          :email,
          :family_name,
          :given_name,
          :invitation_token,
          :password,
          :password_confirmation,
        )
    end
  end
end
