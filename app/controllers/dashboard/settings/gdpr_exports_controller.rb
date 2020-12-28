module Dashboard::Settings
  class GdprExportsController < AuthenticatedController
    def create
      @gdpr_export = GdprExport.create!(
        profile: session_info.profile,
        requested_at: DateTime.now
      )

      GdprExportJob.perform_later(@gdpr_export.id)

      redirect_to(
        dashboard_settings_data_and_privacy_path, flash: {
          success: "Your export has been started. We will email it as soon as it's ready!"
        }
      )
    rescue StandardError => error
      Errors::Reporter.notify(error)

      redirect_to(
        dashboard_settings_data_and_privacy_path, flash: {
          error: "We had a problem starting the export. Please reach out to our support team."
        }
      )
    end
  end
end
