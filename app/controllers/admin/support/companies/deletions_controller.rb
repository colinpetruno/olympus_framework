module Admin::Support::Companies
  class DeletionsController < AdminController
    layout "admin/support"

    def create
      require_token_redemption

      @company = Company.find(params[:company_id])

      redirect_to(
        admin_support_companies_path,
        flash: { success: "Company was deleted" }
      )
    end
  end
end
