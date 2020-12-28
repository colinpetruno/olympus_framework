module Dashboard::Settings
  class AccountDeletionsController < AuthenticatedController
    def create
      sign_out(session_info.member)

      redirect_to(
        root_path,
        flash: {
          success: "Your account was disabled and scheduled for removal"
        }
      )
    end
  end
end
