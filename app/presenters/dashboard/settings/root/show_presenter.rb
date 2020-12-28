module Dashboard::Settings::Root
  class ShowPresenter
    def initialize(session_info)
      @session_info = session_info
    end

    def billing_detail
      # this logic might be better to change to something like backfill
      # the primary from the list and create the primary record instead of
      # assuming which one it is
      session_info.account.primary_billing_detail ||
        session_info.account.billing_details.first ||
        session_info.account.build_primary_billing_detail
    end

    def billing_address
      billing_detail.address || billing_detail.build_address
    end

    def next_image
      image_cycler.next_small_image
    end

    private

    attr_reader :session_info

    def image_cycler
      @_image_cycler ||= DefaultImageCycler.new
    end
  end
end
