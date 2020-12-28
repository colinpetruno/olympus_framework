module ResqueWeb
  class ApplicationController < ::AdminController
    protect_from_forgery
    before_action :set_subtabs, :authorize
    layout "resque_web"

    helper :all

    def self.subtabs(*tab_names)
      return defined?(@subtabs) ? @subtabs : [] if tab_names.empty?
      @subtabs = tab_names
    end

    def set_subtabs(subtabs = self.class.subtabs)
      @subtabs = subtabs
    end

    private

    def authorize
      if ENV["RESQUE_WEB_HTTP_BASIC_AUTH_USER"] && ENV["RESQUE_WEB_HTTP_BASIC_AUTH_PASSWORD"]
        authenticate_or_request_with_http_basic {|u, p| u == ENV["RESQUE_WEB_HTTP_BASIC_AUTH_USER"] && p == ENV["RESQUE_WEB_HTTP_BASIC_AUTH_PASSWORD"] }
      end
    end
  end
end
