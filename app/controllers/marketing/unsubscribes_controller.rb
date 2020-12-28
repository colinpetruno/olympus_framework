module Marketing
  class UnsubscribesController < ApplicationController
    layout "marketing"

    def index
      render :create
    end

    def new
      member = Member.find_by(
        uuid: params[:unsub_id]
      )

      @profile = member&.profile
    end

    def create
      member = Member.find_by!(
        uuid: params[:unsub_id]
      )

      if Members::Unsubscriber.for(member)
        # render create
      else
        redirect_to(
          new_marketing_unsubscribe_path(unsub_id: params[:unsub_id]),
          flash: {
            error: "Something went wrong processing your request. Please contact support"
          }
        )
      end
    end
  end
end
