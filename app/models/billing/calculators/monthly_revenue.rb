module Billing::Calculators
  class MonthlyRevenue
    def self.for(datetime)
      new(datetime).calculate
    end

    def initialize(datetime)
      @datetime = datetime
    end

    def total_revenue
      completed_invoices.sum(:total)
    end

    def collected_revenue
      completed_invoices.sum(:amount_paid)
    end

    def uncollected_revenue
      total_revenue - collected_revenue
    end

    private

    attr_reader :datetime

    def beginning_of_month
      datetime.beginning_of_month
    end

    def end_of_month
      datetime.end_of_month
    end

    def completed_invoices
      # these are invoices that we can book revenue for. It doesn't need to be
      # "paid" to declare revenue. As soon as an agreement is reached, that
      # revenue can be allocated. If for example they sign a contract we can
      # put that revenue on the sheet. If they go out of business and then
      # miss a payment we can then make a collection on their assets to try
      # to recover it. If we can't do that then we can take that as a write
      # down or loss.
      ::Billing::Invoice.where(
        status: [:open, :paid, :uncollectable],
        created_at: (beginning_of_month..end_of_month)
      )
    end
  end
end
