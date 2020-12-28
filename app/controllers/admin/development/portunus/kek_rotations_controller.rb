module Admin::Development::Portunus
  class KekRotationsController < AdminController
    def create
      require_token_redemption
      # TODO: queue job for rake task

      redirect_to(
        admin_development_portunus_root_path,
        flash: { success: "Rotation job scheduled" }
      )
    end
  end
end
