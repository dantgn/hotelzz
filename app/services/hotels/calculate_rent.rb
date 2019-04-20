# frozen_string_literal: true

module Hotels
  class CalculateRent
    def initialize(room_type:, check_in:, check_out:, currency: 'usd')
      @room_type = room_type
      @check_in = check_in
      @check_out = check_out
      @currency = currency
    end

    def call
      "#{total_rent} #{@currency}"
    end

    def amount
      total_rent
    end

    def average
      "#{night_price} #{@currency}/night"
    end

    private

    def total_rent
      total_price = 0
      monthly_prices.each do |month, price|
        total_price +=
          case month
          when first_month
            first_month_rent(price)
          when last_month
            last_month_rent(price)
          else
            price
          end
      end
      total_price.round(2)
    end

    def monthly_prices
      prices = {}

      months_to_pay.each do |month|
        prices[month] = monthly_price(month)
      end

      prices
    end

    def months_to_pay
      (@check_in..@check_out).map(&:month).uniq
    end

    def monthly_price(month)
      @room_type.room_type_prices.find_by(month: month, currency: @currency)&.amount
    end

    def first_month
      @check_in.month
    end

    def last_month
      @check_out.month
    end

    def first_month_rent(price)
      days_month = @check_in.end_of_month.day
      days_rent = @check_in.end_of_month.day - @check_in.day + 1
      price / days_month * days_rent
    end

    def last_month_rent(price)
      days_month = @check_out.end_of_month.day
      days_rent = @check_out.day - 1
      price / days_month * days_rent
    end

    def night_price
      (total_rent / total_rent_days).round(2)
    end

    def total_rent_days
      (@check_out - @check_in).to_i
    end
  end
end
