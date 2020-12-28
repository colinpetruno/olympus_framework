module Dashboard::Settings
  class PendingMembersController < AuthenticatedController
    def index
      @pending_members = Profiles::Finder.for(session_info).pending_for_company
    end

    def update
      @profile = Profile.find(params[:id])

      @profile.update(status: :active)

      # TODO: Queue notifications

      redirect_to(
        dashboard_settings_pending_members_path,
        flash: { success: "#{@profile.email} was approved" }
      )
    end
  end
end
