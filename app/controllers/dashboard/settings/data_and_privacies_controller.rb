module Dashboard
  module Settings
    class DataAndPrivaciesController < AuthenticatedController
      def show
        @gdpr_export ||= GdprExport.
          where(profile: session_info.profile).
          where("created_at > ?", DateTime.now - 30.days).
          order(:created_at).
          last
      end
    end
  end
end
