module HotelzzAPI
  module V1
    class Hotels < Grape::API
      resources :hotels do
        desc 'Get all hotels'
        get do
          hotels = Hotel.all
          present hotels, with: HotelzzAPI::Entities::V1::Light::HotelEntity
        end

        resources :availability do
          desc 'Check hotel availability'
          params do
            requires :check_in, type: Date, desc: 'Date for check in'
            requires :check_out, type: Date, desc: 'Date for check out'
            requires :guests, type: Integer, desc: 'Number of guests in the room'
          end
          get do
            list = []
            Hotel.includes(:room_types).each do |hotel|
              list << {
                'hotelName' => hotel.name,
                'roomTypes' =>
                  ::Hotels::CheckAvailability.new(
                    hotel: hotel,
                    check_in: params[:check_in],
                    check_out: params[:check_out],
                    guests: params[:guests]
                  ).call
              }
            end
            list
          end
        end

        route_param :hotel_id do
          desc 'Get Hotel'
          get do
            hotel = Hotel.includes(:room_types).find(params[:hotel_id])
            present hotel, with: HotelzzAPI::Entities::V1::HotelEntity
          end

          resources :availability do
            desc 'Check hotel availability'
            params do
              requires :check_in, type: Date, desc: 'Date for check in'
              requires :check_out, type: Date, desc: 'Date for check out'
              requires :guests, type: Integer, desc: 'Number of guests in the room'
            end
            get do
              hotel = Hotel.includes(:room_types).find(params[:hotel_id])

              ::Hotels::CheckAvailability.new(
                hotel: hotel,
                check_in: params[:check_in],
                check_out: params[:check_out],
                guests: params[:guests]
              ).call
            end
          end
        end
      end
    end
  end
end
