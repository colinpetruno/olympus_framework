module Marketing
  module Remote
    class BetaRequestsController < ApplicationController
      def create
        BetaRequest.create(beta_request_params)

        render "create", format: :js
      end

      private

      def beta_request_params
        params.require(:beta_request).permit(:email, :interview, :beta_test)
      end
    end
  end
end
