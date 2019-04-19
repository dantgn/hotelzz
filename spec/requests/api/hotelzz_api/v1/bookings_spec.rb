require 'rails_helper'

RSpec.shared_examples('when authentication fails') do
  let(:expected_response) do
    { 'error' => '401 Unauthorized' }
  end

  it 'returns authorization error' do
    subject

    expect(JSON.parse(response.body)).to eq(expected_response)
    expect(response.status).to eq(401)
  end
end

RSpec.describe HotelzzAPI::V1::Bookings, type: :request do
  subject { post request_url }
  let(:check_in) { '2020/01/01' }
  let(:check_out) { '2020/02/01' }

  describe 'POST /api/v1/bookings' do
    let(:request_url) { "/api/v1/bookings" }

    context 'when required parameters are not provided' do
      let(:expected_response) do
        {
          'error' => 'check_in is missing, check_out is missing, room_type_id is missing'
        }
      end

      it 'returns an error' do
        subject

        expect(JSON.parse(response.body)).to eq(expected_response)
        expect(response.status).to eq(400)
      end
    end

    context 'when required parameters are provided' do
      subject { post request_url, params: request_params }
      let!(:room_type) { Fabricate(:room_type, number_of_rooms: 1) }
      let(:request_params) do
        {
          check_in: check_in,
          check_out: check_out,
          room_type_id: room_type.id
        }
      end

      context 'and auth token no provided in headers' do
        include_examples 'when authentication fails'
      end

      context 'and auth token is provided in headers' do
        subject { post request_url, params: request_params, headers: headers }

        context 'and authentication fails' do
          include_examples 'when authentication fails'
        end

        context 'and authentication succeeds' do
          let!(:guest) { Fabricate(:guest) }

          before do
            allow(Authentication::JsonWebToken).
              to receive(:decode).
              and_return(guest_id: guest.id)
          end

          context 'and no bookings for selected dates available' do
            let!(:booking) do
              Fabricate(:booking, check_in: check_in, check_out: check_out, hotel: room_type.hotel, room_type: room_type)
            end
            let(:expected_response) do
              { 'error' => 'Room Type not available for booking on selected dates' }
            end

            it 'returns error' do
              subject

              expect(JSON.parse(response.body)).to eq(expected_response)
              expect(response.status).to eq(422)
            end
          end

          context 'and booking available for selected dates' do
            let(:calculate_rent_service) { instance_double('Hotels::CalculateRent') }
            let(:payment_service) { instance_double(Stripe::ChargePayment) }
            let(:rent) { 1200 }

            before do
              allow(Hotels::CalculateRent).
                to receive(:new).
                with(
                  room_type: room_type,
                  check_in: check_in.to_date,
                  check_out: check_out.to_date
                ).
                and_return(calculate_rent_service)

              allow(calculate_rent_service).
                to receive(:amount).
                and_return(rent)

              allow(Stripe::ChargePayment).
                to receive(:new).
                and_return(payment_service)
            end

            context 'and payment failed' do
              let(:expected_response) do
                { 'error' => 'Payment transaction failed!' }
              end

              before do
                allow(payment_service).
                  to receive(:call).
                  and_return(false)
              end

              it 'returns error' do
                subject

                expect(JSON.parse(response.body)).to eq(expected_response)
                expect(response.status).to eq(422)
              end
            end

            context 'and payment succeeded' do
              let(:expected_response) do
                {
                  'check_in' => check_in.parameterize,
                  'check_out' => check_out.parameterize,
                  'guest' => {
                    'email' => guest.email,
                    'first_name' => guest.first_name,
                    'last_name' => guest.last_name,
                    'id' => guest.id
                  },
                  'id' => Booking.last.id,
                  'room_type' => {
                    'hotel_id' => room_type.hotel_id,
                    'id' => room_type.id,
                    'name' => room_type.name,
                    'occupancy_limit' => room_type.occupancy_limit,
                  }
                }
              end

              before do
                allow(payment_service).
                  to receive(:call).
                  and_return(true)
              end

              it 'returns booking details' do
                subject

                expect(JSON.parse(response.body)).to eq(expected_response)
                expect(response.status).to eq(201)
              end
            end
          end
        end
      end
    end
  end
end
