module HotelzzAPI
  module V1
    class Root < Grape::API
      include ::HotelzzAPI::Errors

      default_format :json
      content_type :json, 'application/json'

      mount HotelzzAPI::V1::Hotels
      mount HotelzzAPI::V1::Bookings
    end
  end
end
