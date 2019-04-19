module HotelzzAPI
  module V1
    class Bookings < Grape::API
      include ::HotelzzAPI::Errors

      helpers ::HotelzzAPI::Helpers::JwtAuthenticationHelper

      resources :bookings do
        desc 'Create a booking'
        params do
          requires :check_in, type: Date, desc: 'Date for check in'
          requires :check_out, type: Date, desc: 'Date for check out'
          requires :room_type_id, type: Integer, desc: 'ID of the Room type to book'
        end
        post do
          raise Errors::AuthenticationError unless (guest = authenticated_jwt_guest?)

          room_type = RoomType.find(params[:room_type_id])
          check_in = params[:check_in].to_date
          check_out = params[:check_out].to_date

          unless room_type.available?(check_in: check_in, check_out: check_out)
            raise Errors::UnavailableBookingForRoomType
          end

          booking = Booking.create!(
            hotel_id: room_type.hotel_id, # eventually this foreign key can go away
            guest_id: guest.id,
            check_in: check_in,
            check_out: check_out,
            room_type_id: room_type.id
          )
          rent = ::Hotels::CalculateRent.new(
            room_type: room_type,
            check_in: check_in,
            check_out: check_out
          ).amount

          unless Stripe::ChargePayment.new(booking: booking, amount: rent).call
            raise Errors::BookingPaymentFailed
          end

          present booking, with: HotelzzAPI::Entities::V1::BookingEntity
        end
      end
    end
  end
end
