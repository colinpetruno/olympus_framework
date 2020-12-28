module Marketing
  class StaticPagesController < MarketingController
    def connect
      @hide_header = true
      @hide_footer = true

      redirect_to(dashboard_root_path) and return if current_member.present?
    end

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
