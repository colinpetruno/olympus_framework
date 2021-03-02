# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Pagy::Backend
  before_action :enroll_admin_if_required?
  before_action :track_page_view

  helper_method :session_info
  def session_info
    return nil if current_member.blank?

    @_session_info ||= Members::SessionInfo.new(member: current_member)
  end

  def after_sign_out_path_for(_resource_or_scope)
    homepage_path
  end

  def ichnaea_user
    return nil if current_member.blank?

    current_member.profile
  end

  def require_token_redemption
    auth_log = TwoFactorAuthLog.where(
      auth_status: :succeeded,
      member: current_member,
      authed_on: (DateTime.now - 5.minutes)..DateTime.now,
      redeemed_at: nil
    ).find_by!(two_factor_redemption_params)

    auth_log.update!(
      redeemed_at: DateTime.now,
      redeemed_by: [controller_path, action_name].join("#")
    )
  end

  def track_page_view
    # try to avoid tracking bots and get requests
    return if Browser.new(request.user_agent).bot? || !request.get?

    Ichnaea::TrackPageviewJob.perform_later(
      session.id.to_s,
      session_info&.profile&.id,
      session_info&.profile&.class&.name,
      {
        request_information: ::Ichnaea::RequestInformation.for(request),
        viewed_at: DateTime.now,
        event_payload: {
          controller: controller_path,
          action: action_name,
          page: "#{controller_path}##{action_name}"
        }
      }.to_json
    )
  end

  private

  def enroll_admin_if_required?
    return if Rails.env.test?

    unless Olympus.settings.admin_created?
      redirect_to(admin_enrollments_path) and return
    end
  end

  def two_factor_redemption_params
    params.require(:two_factor_redemption).permit(:id)
  end
end
