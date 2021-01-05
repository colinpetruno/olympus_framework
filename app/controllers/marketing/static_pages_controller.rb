module Marketing
  class StaticPagesController < MarketingController
    def homepage
    end

    def about_us
    end

    def pricing
    end

    def contact_us
      @contact_us = ContactUsRequest.new
    end
  end
end
