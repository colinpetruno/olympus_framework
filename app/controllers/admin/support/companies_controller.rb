module Admin::Support
  class CompaniesController < AdminController
    layout "admin/support"

    def index
      @pagy, @companies = pagy(Company.all)
    end

    def show
      @company = Company.find(params[:id])
    end

    def update
      require_token_redemption

      redirect_to(
        admin_support_company_path,
        flash: {
          success: "The company was updated"
        }
      )
    end

    private

    def company_params
      params.require(:company).permit(:open_signups, :email_domain)
    end
  end
end
