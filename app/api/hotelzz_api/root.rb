module HotelzzAPI
  class Root < Grape::API
    mount HotelzzAPI::V1::Root => '/api/v1/'
  end
end
