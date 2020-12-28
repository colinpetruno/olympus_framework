module Routable
  def routes
    Rails.application.routes.url_helpers
  end
end
