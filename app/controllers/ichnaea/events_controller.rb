module Ichnaea
  class EventsController < ApplicationController
    skip_before_action :track_page_view

    def create
      ::Ichnaea::TrackEventJob.perform_later(
        session.id.to_s,
        ichnaea_user&.id,
        ichnaea_user&.class.name,
        ichnaea_params.merge({
          url: request.referrer,
          request_information: ::Ichnaea::RequestInformation.for(request),
          event_time: DateTime.now
        }).to_json
      )
    end

    private

    def ichnaea_params
      params.require(:ichnaea_event).permit(:event_name, event_payload: {})
    end
  end
end
