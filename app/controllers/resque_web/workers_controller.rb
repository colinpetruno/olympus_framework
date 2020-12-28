module ResqueWeb
  class WorkersController < ResqueWeb::ApplicationController
    before_action :display_subtabs

    def index
    end

    def show
      if params[:id] && params[:id] != "all"
        @workers = view_context.worker_hosts[params[:id]].map do |id|
          Resque::Worker.find(id)
        end
      else
        @workers = Resque.workers
      end
    end

    private

    def display_subtabs
      set_subtabs view_context.worker_hosts.map(&:first)
    end
  end
end
