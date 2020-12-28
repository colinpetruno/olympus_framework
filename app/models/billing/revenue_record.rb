module Billing
  class RevenueRecord < ApplicationRecord
    enum period: {
      day: 0,    # 20200111
      week: 1,   # 20201108
      month: 2,  # 202011
      year: 3    # 2020
    }

    def datetime_obj
      if day? || week?
        DateTime.parse("#{date}")
      elsif month?
        DateTime.parse("#{date}01")
      elsif year?
        DateTime.parse("#{date}0101")
      end
    end
  end
end
