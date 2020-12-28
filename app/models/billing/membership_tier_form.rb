module Billing
  class MembershipTierForm
    include ::ActiveModel::Model

    attr_reader :billing_product_id, :interval
  end
end
