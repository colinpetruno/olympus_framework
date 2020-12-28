module Dashboard
  class SupportRequestsController < AuthenticatedController
    layout "billing"

    def index
      @support_requests = SupportRequest.where(
        supportable: session_info.profile,
        deleted_at: nil,
        resolved_at: nil
      )
    end

    def create
      @support_request = SupportRequest.new(support_request_params)
      @message = @support_request.support_request_messages.first

      # Note: This is intended to make this system fail into a safe state. If
      # a dev accidently forgets about this the worst result is the message is
      # hidden. If set the other way the worst result is leaked internal data
      # possibly causing PR headaches.
      @message.hidden_from_customer = false
      @message.sent_by_staff = false
      @message.sent_at = DateTime.now
      @message.sendable = session_info.profile

      if @support_request.save!
        redirect_to(
          dashboard_support_requests_path,
          flash: { success: "We received your request and will get back to you as soon as possible" }
        )
      else
        render :index
      end
    end

    private

    def support_request_params
      params.
        require(:support_request).
        permit(
          support_request_messages_attributes: [:message]
        ).merge(
          submitted_at: DateTime.now,
          supportable: session_info.profile,
          company: session_info.company
        )
    end
  end
end
