module Ichnaea
  class EventParams
    def initialize(params)
      @params = params
    end

    private

    attr_reader :params
  end
end
