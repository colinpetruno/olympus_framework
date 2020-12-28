module Errors
  class Reporter
    def self.notify(error, raise_in_development=true)
      # hook for error reporting
      if (Rails.env.development? || Rails.env.text?) && raise_in_development
        raise error
      end
    end
  end
end
