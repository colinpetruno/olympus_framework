module Billing::Subscriptions
  class Finder
    def self.for(ownerable)
      new(ownerable).find_active
    end

    def initialize(ownerable)
      @ownerable = ownerable
    end

    def find_active
      ::Billing::Subscription.
        where("paid_until_date > ?", DateTime.now.to_i).
        find_by(
          ownerable: ownerable,
          active: true
        )
    end

    private

    attr_reader :ownerable
  end
end
