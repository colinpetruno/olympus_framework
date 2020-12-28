module Billing
  class SourceFinder
    def self.for(session_info)
      new(session_info).find
    end

    def initialize(session_info)
      @session_info = session_info
    end

    def find
      ::Billing::Source.where(
        sourceable: session_info.account,
        deleted_at: nil
      )
    end

    def default
      ::Billing::Source.find_by!(
        sourceable: session_info.account,
        default: true,
        deleted_at: nil
      )
    end

    private

    attr_reader :session_info
  end
end
