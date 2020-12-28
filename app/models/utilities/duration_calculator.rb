module Utilities
  class DurationCalculator
    def initialize(start_time:, end_time:)
      @start_time = start_time
      @end_time = end_time

      [start_time, end_time].each do |time|
        if time.class.name != "DateTime"
          StandardError.new("Unsupported time format")
        end
      end
    end

    def hours
      (minutes.to_f / 60.to_f).round(2)
    end

    def minutes
      (seconds.to_f / 60.to_f).round(2)
    end

    def seconds
      end_time.to_i - start_time.to_i
    end

    private

    attr_reader :start_time, :end_time
  end
end
