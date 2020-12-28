module Admin::Finance
  class DashboardsController < AdminController
    layout "admin/finance"

    def show
      @todays_revenue = Billing::Calculators::TodaysRevenue.for(DateTime.now)
    end
  end
end
