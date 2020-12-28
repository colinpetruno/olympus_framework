module Admin::Support
  class MembersController < AdminController
    layout "admin/support"

    def index
      @pagy, @members = pagy(Member.all.includes(:profile), items: 1)
    end

    def show
      member = Member.find_by(uuid: params[:id])

      @presenter = ::Admin::Support::Members::ShowPresenter.for(member)
    end
  end
end
