module Admin::Support
  class SupportRequestsController < AdminController
    layout "admin/support"

    def index
      @pagy, @support_requests = pagy(
        SupportRequest.
          where(resolved_at: nil, deleted_at: nil).
          order(submitted_at: :asc).
          joins(:support_request_messages)
      )
    end

    def update
      # NOTE: only resolve is hitting this at the moment
      @support_request = SupportRequest.find_by(uuid: params[:id])

      @support_request.update!(
        resolved_at: DateTime.now,
        resolvable: session_info.profile
      )

      redirect_to(
        admin_support_support_requests_path,
        flash: { success: "Support request was resolved and closed" }
      )
    end

    def show
      @support_request = SupportRequest.find_by(uuid: params[:id])
    end

    def destroy
      @support_request = SupportRequest.find_by(uuid: params[:id])

      @support_request.update(deleted_at: DateTime.now)

      redirect_to(
        admin_support_support_requests_path,
        flash: { success: "Support request was deleted." }
      )
    end
  end
end
