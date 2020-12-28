module Billing
  class Source < ApplicationRecord
    include NotDeletable

    belongs_to :sourceable, polymorphic: true

    before_save :check_default

    belongs_to(
      :billing_detail,
      class_name: "::Billing::Detail",
      foreign_key: :billing_detail_id
    )
    accepts_nested_attributes_for :billing_detail

    has_one(
      :billing_external_id,
      class_name: "::Billing::ExternalId",
      as: :objectable
    )
    accepts_nested_attributes_for :billing_external_id

    encrypted_fields :last_four
    attr_scrubbable :last_four, :exp_year, :exp_month, :brand
    attr_exportable :last_four, :exp_year, :exp_month, :brand

    enum source_type: {
      card: 0
    }

    private

    def check_default
      return if !default? && !only_source?

      if only_source?
        self.default = true
      else
      ::Billing::Source.
        where(sourceable_id: sourceable_id, sourceable_type: sourceable_type).
        update_all(default: false)
      end
    end

    def only_source?
      if persisted?
        ::Billing::Source.where(sourceable_id: sourceable_id, sourceable_type: sourceable_type).size == 1
      else
        ::Billing::Source.where(sourceable_id: sourceable_id, sourceable_type: sourceable_type).size == 0
      end
    end
  end
end
