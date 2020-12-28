module Dashboard
  module Onboarding
    class CompaniesController < AuthenticatedController
      layout "billing"

      def update
        session_info.company.update(company_params)

        redirect_to(dashboard_onboarding_calendars_path)
      end

      private

      def company_params
        params.require(:company).permit(:email_domain, :open_signups, :name)
      end
    end
  end
end
