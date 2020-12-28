module Timezones
  class Finder
    def self.for(object)
      new(object: object).find
    end

    def initialize(object:)
      @object = object
    end

    def find
      if object.is_a?(Profile)
        # tz.tzinfo.canonical_identifier.to_s
        ActiveSupport::TimeZone.new(object.timezone)
      else
        raise StandardError.new(
          "Unsupported object type: #{object.class.name}"
        )
      end
    end

    private

    attr_reader :object
  end
end
