module Dashboard
  module Settings
    class CompaniesController < AuthenticatedController
      def index
      end

      def update
        session_info.company.update(company_params)

        redirect_to(
          dashboard_settings_root_path,
          flash: { success: "Your settings have been updated" }
        )
      end

      private

      def company_params
        params
          .require(:company)
          .permit(
            :email_domain,
            :name,
            :open_signups
          )
      end
    end
  end
end
