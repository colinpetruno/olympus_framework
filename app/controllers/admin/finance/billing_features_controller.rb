module Admin::Finance
  class BillingFeaturesController < AdminController
    layout "admin/finance"

    def index
      @billing_features = Billing::Feature.all
    end

    def new
      @billing_feature = Billing::Feature.new
    end

    def create
      @billing_feature = Billing::Feature.new(billing_feature_params)

      if @billing_feature.save
        redirect_to(
          admin_finance_billing_features_path,
          flash: { success: "Billing feature was created" }
        )
      else
        render :new
      end
    end

    def edit
      @billing_feature = Billing::Feature.
        includes(billing_product_features: [:billing_product]).
        find(params[:id])
    end

    def update
      @billing_feature = Billing::Feature.find(params[:id])

      if @billing_feature.update(billing_feature_params)
        redirect_to(
          admin_finance_billing_features_path,
          flash: { success: "Billing feature was updated" }
        )
      else
        render :new
      end
    end

    private

    def billing_feature_params
      params
        .require(:billing_feature)
        .permit(
          :feature_name,
          :feature_key,
          :enabled,
          :measuring_type,
          :quantity,
          :unlimited,
          billing_product_features_attributes: [
            :id,
            :measuring_type,
            :unlimited,
            :enabled,
            :quantity
          ]
        )
    end
  end
end
