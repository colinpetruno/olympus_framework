module Dashboard::Company
  class PendingMembersController < AuthenticatedController
    layout "billing"

    skip_before_action :ensure_active_profile
    skip_before_action :check_broken_connections!

    def index
    end
  end
end
