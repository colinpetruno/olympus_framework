module Utilities::Time
  class Difference
    # https://stackoverflow.com/questions/19595840/rails-get-the-time-difference-in-hours-minutes-and-seconds
    def self.as_string(start_time, end_time)
      seconds_diff = (start_time.to_i - end_time.to_i).to_i.abs

      days = seconds_diff / 86400
      seconds_diff -= days * 86400

      hours = seconds_diff / 3600
      seconds_diff -= hours * 3600

      minutes = seconds_diff / 60
      seconds_diff -= minutes * 60

      seconds = seconds_diff

      [
        days.to_s.rjust(2, "0"),
        hours.to_s.rjust(2, "0"),
        minutes.to_s.rjust(2, "0"),
        seconds.to_s.rjust(2, "0")
      ].join(":")
    end
  end
end
