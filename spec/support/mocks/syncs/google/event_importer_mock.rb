module Syncs::Google
  class EventImporterMock
    def self.import(event, calendar, session_info)
      true
    end
  end
end
