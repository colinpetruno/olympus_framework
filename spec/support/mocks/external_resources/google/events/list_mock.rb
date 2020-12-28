module ExternalResources::Google::Events
  class ListMock
    def initialize(calendar:, session_info:)
    end

    def next_page?
      @_page_count = page_count + 1

      @_page_count < 3
    end

    def list_next_page
      # this is where the event structure needs to come from
      response.items
    end

    def page_number
      page_count
    end

    def next_sync_token
      "asdfasfd"
    end

    private

    def response
      @_response = ::Google::Apis::CalendarV3::Events.new(
        json_response.symbolize_keys
      )
    end

    def json_response
      JSON.parse(File.read(Rails.root.join(
        "spec",
        "support",
        "files",
        "external_resources",
        "google",
        "list_events_response.json"
      )))
    end

    def page_count
      @_page_count ||= 0
    end
  end
end
