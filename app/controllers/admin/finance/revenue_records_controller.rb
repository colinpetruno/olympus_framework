module Admin::Finance
  class RevenueRecordsController < AdminController
    layout "admin/finance"

    def index
      @revenue_records = ::Billing::RevenueRecord.
        where(period: :month).
        order(date: :desc)
    end
  end
end
