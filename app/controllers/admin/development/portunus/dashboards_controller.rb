module Admin::Development::Portunus
  class DashboardsController < AdminController
    layout "admin/development"

    def show
      @dek_counts_by_master = ::Portunus::Queries::DekCountByMasterKey.
        get_counts
    end
  end
end
