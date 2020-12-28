module Utilities
  class SessionTimezonesController < ApplicationController
    def create
      if ActiveSupport::TimeZone.find_tzinfo(params["timezone"]).present?
        session[:application_timezone] = params["timezone"]
      end
    end
  end
end
