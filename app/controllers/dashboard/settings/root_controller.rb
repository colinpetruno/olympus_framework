module Dashboard::Settings
  class RootController < AuthenticatedController
    def show
      @presenter = ::Dashboard::Settings::Root::ShowPresenter.new(session_info)
    end
  end
end
