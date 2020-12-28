module Billing::Services
  class GenerateRevenueReports
    def self.generate_for(start_date:, end_date:, frequency:, test: false)
      new(
        start_date: start_date,
        end_date: end_date,
        frequency: frequency,
        test: false
      ).generate
    end

    def initialize(start_date:, end_date:, frequency:, test: false)
      @start_date = start_date
      @end_date = end_date
      @frequency = frequency.to_sym
      @test = test
    end

    def generate
      @tracking_date = start_date.dup

      while tracking_date <= end_date
        amounts = amount_collected_for(tracking_date)
        collected = amounts.first
        uncollected = amounts.last

        # ensure no duplicate records
        ::Billing::RevenueRecord.upsert({
          collected: collected,
          uncollected: uncollected,
          total: collected + uncollected,
          date: integer_date(tracking_date),
          period: frequency
        }, unique_by: [:date, :period])

        @tracking_date = tracking_date + interval
      end

      reset!

      return true
    end

    private

    attr_reader :start_date, :end_date, :frequency, :tracking_date

    def integer_date(target_date)
      if frequency == :month
        target_date.strftime("%Y%m")
      elsif frequency == :week
        target_date.beginning_of_week.strftime("%Y%m%d")
      elsif frequency == :day
        target_date.strftime("%Y%m%d")
      else
        raise StandardError.new("Unsupported interval type #{frequency}")
      end
    end

    def test?
      @test
    end

    def base_scope
      ::Billing::Invoice.select(
        "sum(collected) as total_collected",
        "sum(uncollected) as total_uncollected"
      )
    end

    def amount_collected_for(date)
      if frequency == :month
        base_scope = ::Billing::Invoice.where(
          created_at: (date.beginning_of_month..date.end_of_month)
        )
      elsif frequency == :week
        base_scope = ::Billing::Invoice.where(
          created_at: (date.beginning_of_week..date.end_of_week)
        )
      elsif frequency == :day
        base_scope = ::Billing::Invoice.where(
          created_at: (date.beginning_of_day..date.end_of_day)
        )
      else
        raise StandardError.new("Unsupported interval type #{frequency}")
      end

      if !test?
        # In non prod environments we will just return some fake numbers so
        # that we can get some realistic looking data to play with without
        # doing weird transactions
        dev_values
      else
        base_scope.pluck(
          "sum(amount_paid) as total_collected",
          "sum(amount_remaining) as total_uncollected"
        ).first
      end
    end

    def dev_values
      [rand(930..1200), rand(50..200)].map { |v| v * dev_multiplier }
    end

    def dev_multiplier
      if frequency == :month
        30
      elsif frequency == :week
        7
      elsif frequency == :day
        1
      else
        raise StandardError.new("Unsupported interval type #{frequency}")
      end
    end

    def interval
      if frequency == :month
        1.month
      elsif frequency == :week
        1.week
      elsif frequency == :day
        1.day
      else
        raise StandardError.new("Unsupported interval type #{frequency}")
      end
    end

    def reset!
      @tracking_date = start_date.clone
    end
  end
end
