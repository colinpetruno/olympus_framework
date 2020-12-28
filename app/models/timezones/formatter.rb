module Timezones
  class Formatter
    def self.for(timezone)
      new(timezone).format
    end

    def initialize(timezone)
      @timezone = timezone
    end

    def format
      [
        "(GMT#{timezone.now.formatted_offset})",
        timezone.tzinfo.friendly_identifier
      ].join(" ")
    end

    private

    attr_reader :timezone
  end
end
