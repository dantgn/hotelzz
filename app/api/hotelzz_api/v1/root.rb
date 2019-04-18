module HotelzzAPI
  module V1
    class Root < Grape::API
      default_format :json

      mount HotelzzAPI::V1::Hotels
    end
  end
end
