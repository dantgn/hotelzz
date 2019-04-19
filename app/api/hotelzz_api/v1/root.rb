module HotelzzAPI
  module V1
    class Root < Grape::API
      default_format :json
      content_type :json, 'application/json'

      mount HotelzzAPI::V1::Hotels
    end
  end
end
