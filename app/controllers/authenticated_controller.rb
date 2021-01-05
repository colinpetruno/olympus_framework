class AuthenticatedController < ApplicationController
  include Pundit

  # order for authenticate user and protect from forgery is important. The user
  # must come first now
  before_action :authenticate_member!
  before_action :protect_against_forgery?
  before_action :ensure_active_profile

  before_action :check_broken_connections!

  layout "dashboard"

  def pundit_user
    session_info
  end

  def check_broken_connections!
    if session_info.broken_connections?
      redirect_to(
        dashboard_connections_path,
        flash: { error: "Your connections may be broken. Please reauth or remove any broken connections" }
      ) and return
    end
  end

  private

  def ensure_active_profile
    if session_info.profile.pending?
      redirect_to(dashboard_company_pending_members_path) and return
    elsif session_info.profile.disabled? || session_info.profile.deleted?
      sign_out(current_member)

      redirect_to(
        root_path,
        flash: { error: "This account is not active. Contact your account owner to activate it" }
      ) and return
    end
  end

  def check_two_factor_auth
    if two_factor_auth_status.needs_authed?
      session[:two_factor_redirect_url] = request.url
      redirect_to new_auth_two_factor_session_path and return
    else
      session[:two_factor_last_activity] =  DateTime.now.utc.to_i
    end
  end

  def two_factor_auth_status
    @_two_factor_auth_status ||= TwoFactorAuthentications::Status.for(
      current_member,
      session
    )
  end

  def require_password_confirmation(redirect_path, duration = 10.minutes)
    return true unless current_member.password?

    confirmations = PasswordConfirmationLog.
      where(member: current_member).
      where("confirmed_at > ?", (DateTime.now - duration))


    if confirmations.blank?
      session[:password_confirmation_redirect] = redirect_path
      redirect_to new_auth_password_confirmation_path and return
    end
  end
end
