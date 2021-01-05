module Authentication
  class SignupsController < MarketingController
    layout "art_pane"

    def new
      @signup_form = Authentication::Forms::SignupForm.new

      redirect_to(dashboard_root_path) and return if current_member.present?
    end

    def create
      @form = Authentication::Forms::SignupForm.new(signup_params)

      if @form.sign_up
        sign_in(@form.member)
        redirect_to_path = redirect_path.dup
        # Ensure the session is cleaned up
        session[:signin_redirect_path] = nil

        redirect_to(redirect_to_path) and return
      else
        @form.password = nil
        @form.password_confirmation = nil

        render :new
      end
    end

    private

    def redirect_path
      session[:signup_redirect_path] || dashboard_root_path
    end

    def signup_params
      params.
        require(:signup).
        permit(
          :email,
          :given_name,
          :family_name,
          :password,
          :password_confirmation
        )
    end
  end
end
