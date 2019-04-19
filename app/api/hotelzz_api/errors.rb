module HotelzzAPI
  module Errors
    extend ActiveSupport::Concern

    AuthenticationError = Class.new(StandardError)
    UnavailableBookingForRoomType = Class.new(StandardError)
    BookingPaymentFailed = Class.new(StandardError)

    included do
      rescue_from UnavailableBookingForRoomType do
        error!('Room Type not available for booking on selected dates', 422)
      end

      rescue_from BookingPaymentFailed do
        error!('Payment transaction failed!', 422)
      end

      rescue_from JWT::DecodeError, AuthenticationError do
        error!('401 Unauthorized', 401)
      end
    end
  end
end
