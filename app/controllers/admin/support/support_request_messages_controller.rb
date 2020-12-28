module Admin::Support
  class SupportRequestMessagesController < AdminController
    layout "admin/support"

    def create
      @support_request = SupportRequest.find_by(
        uuid: params[:support_request_id]
      )

      @support_request.support_request_messages.create!(
        support_request_message_params
      )

      redirect_to(
        admin_support_support_request_path(@support_request),
        flash: { success: "Your message was created successfully" }
      )
    end

    private

    def support_request_message_params
      params.
        require(:support_request_message).
        permit(:message).
        merge(
          sendable: session_info.profile,
          sent_by_staff: true,
          hidden_from_customer: false,
          sent_at: DateTime.now
        )
    end
  end
end
