class AdminController < AuthenticatedController
  before_action :ensure_admin
  before_action :check_two_factor_auth
  # TODO: add an admin check here

  private

  def ensure_admin
    unless current_member.application_admin?
      redirect_to root_path and return
    end
  end
end
