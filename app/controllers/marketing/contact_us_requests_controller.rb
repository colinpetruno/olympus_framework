module Marketing
  class ContactUsRequestsController < ApplicationController
    layout "marketing"

    def new
      @contact_us_request = ContactUsRequest.new
    end

    def index
      render :create
    end

    def create
      @contact_us_request = ContactUsRequest.new(contact_us_request_params)

      if @contact_us_request.save
        # we should try to find the member email if it does not exist so
        # we can associate with the support request
        @support_request = SupportRequest.create(
          company: session_info&.company,
          profile: session_info&.provile,
          supportable: @contact_us_request,
          submitted_at: DateTime.now
        )

        SupportMailer.new_support_request(@support_request).deliver_later
      else
        render :new
      end
    end

    private

    def contact_us_request_params
      params.
        require(:contact_us_request).
        permit(:category, :email, :request).
        merge(submitted_at: DateTime.now)
    end
  end
end
