module Utilities
  module Time
    class UnixToDateTime
      def self.for(unix_time)
        return nil if unix_time.blank?

        DateTime.strptime(unix_time.to_s,'%s')
      end
    end
  end
end
