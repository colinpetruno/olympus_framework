module Authentication
  class SigninsController < MarketingController
    layout "art_pane"

    def new
      @signin_form = Authentication::Forms::SigninForm.new

      redirect_to(dashboard_root_path) and return if current_member.present?
    end

    def create
      @signin_form = Authentication::Forms::SigninForm.new(signin_params)

      if @signin_form.sign_in?
        sign_in(@form.member)
        redirect_to_path = redirect_path.dup
        # Ensure the session is cleaned up
        session[:signin_redirect_path] = nil

        redirect_to(redirect_to_path) and return
      else
        @signin_form.password = nil
        render :new
      end
    end

    private

    def redirect_path
      session[:signin_redirect_path] || dashboard_root_path
    end

    def signin_params
      params.
        require(:signin).
        permit(:email, :password)
    end
  end
end
