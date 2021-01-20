module Dashboard::Settings
  class BillingSourcesController < AuthenticatedController
    layout "art_pane/billing"

    def new
      @source = ::Billing::Source.new
    end

    def create
      @source = ::Billing::Source.new(source_params)

      if @source.save
        stripe_source_id = @source.billing_external_id.external_id
        customer = ::Billing::CustomerFinder.for(session_info)

        ::Stripe::Source.update(
          stripe_source_id,
          {
            owner: {
              email: session_info.profile.email,
              name: session_info.profile.full_name,
              address: {
                city: @source.billing_detail.address.city,
                country: @source.billing_detail.address.country_code,
                line1: @source.billing_detail.address.line_1,
                line2: @source.billing_detail.address.line_2,
                postal_code: @source.billing_detail.address.postalcode,
                state: @source.billing_detail.address.province
              }
            },
            metadata: {
              application_id: @source.id
            }
          },
        )

        Stripe::Customer.create_source(
          customer.billing_external_id.external_id,
          {
            source: @source.billing_external_id.external_id,
          }
        )
      end

      if @source.persisted?
        redirect_to dashboard_settings_billings_path
      else
        render :new
      end
    end

    def update
      # this action only lets someone promote to default
      @source = ::Billing::Source.
        where(sourceable: session_info.account).
        find(params[:id])

      subscription = ::Billing::Subscriptions::Finder.for(
        session_info.account
      )

      if subscription.present?
        ::Billing::Subscriptions::SetDefaultSource.for(
          session_info,
          @source
        )
      end

      @source.update(default: true)

      redirect_to dashboard_settings_billings_path
    end

    def destroy
      @source = ::Billing::Source.
        where(sourceable: session_info.account).
        find(params[:id])

      @source.update(deleted_at: DateTime.now)

      redirect_to dashboard_settings_billings_path
    end

    private

    def source_params
      params.
        require(:billing_source).
        permit(
          :default,
          :exp_year,
          :exp_month,
          :brand,
          :last_four,
          {
            billing_detail_attributes: [
              :entity_type,
              :entity_name,
              :tax_number,
              {
                address_attributes: [
                  :line_1,
                  :line_2,
                  :city,
                  :province,
                  :postalcode
                ]
              }
            ],
            billing_external_id_attributes: [:external_id]
          }
        ).
        to_h.
        deep_merge(
          sourceable: session_info.account,
          source_type: :card,
          created_by_id: session_info.profile.id,
          billing_detail_attributes: {
            detailable: session_info.account,
            address_attributes: {
              company_id: session_info.company.id
            }
          }
        )
    end
  end
end
