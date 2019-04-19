module HotelzzAPI
  module V1
    class RoomTypes < Grape::API
      helpers ::HotelzzAPI::Helpers::JwtAuthenticationHelper

      resources :room_types do
        route_param :room_type_id do
          desc 'Update room type price'
          params do
            requires :month, type: Integer, desc: 'Month to update the price'
            requires :amount, type: Float, desc: 'Amount to be updated'
            optional :currency, type: String, desc: 'Currency of the new price', default: 'usd'
          end
          resources :prices do
            put do
              raise Errors::AuthenticationError unless (hotel_manager = jwt_authenticated_user('HotelManager'))

              room_type = RoomType.find(params[:room_type_id])
              raise Errors::AuthorizationError unless hotel_manager.hotels.ids.include?(room_type.hotel_id)

              price = RoomTypePrice.find_by(
                month: params[:month],
                room_type_id: params[:room_type_id]
              )
              price.update_attributes!(amount: params[:amount], currency: params[:currency])

              present price, with: HotelzzAPI::Entities::V1::RoomTypePriceEntity
            end
          end
        end
      end
    end
  end
end
