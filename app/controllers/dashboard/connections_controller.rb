module Dashboard
  class ConnectionsController < AuthenticatedController
    skip_before_action :check_broken_connections!

    def index
      @auth_credential_statuses = AuthCredentials::Finder.
        new(session_info).
        find_with_statuses
    end

    def destroy
      auth_credential = AuthCredential.find(params[:id])

      authorize([:dashboard, auth_credential])

      if ::AuthCredentials::Disconnect.for(auth_credential)
        redirect_to dashboard_connections_path
      else
        redirect_to dashboard_connections_path
      end
    end
  end
end
