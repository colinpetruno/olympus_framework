module Admin::Finance
  class BillingProductsController < AdminController
    layout "admin/finance"

    def index
      @products = Billing::Product.all.order(:name)
    end

    def edit
      @product = Billing::Product.find(params[:id])

      # we want to make sure all the features are built for this product
      Billing::Products::FeatureAuditor.for(@product)
    end

    def update
      @product = Billing::Product.find(params[:id])

      if billing_product_params[:subscription_default]
        ApplicationRecord.transaction do
          Billing::Product.update_all(subscription_default: false)
          # reload is important here since the obj is in memory when the
          # previous line is run and updates the record in the database
          @product.reload.update!(billing_product_params)
        end
      else
        @product.update(billing_product_params)
      end

      redirect_to(
        admin_finance_billing_products_path,
        flash: { success: "Product was updated successfully" }
      )
    end

    private

    def billing_product_params
      params
        .require(:billing_product)
        .permit(
          :subscription_default,
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
