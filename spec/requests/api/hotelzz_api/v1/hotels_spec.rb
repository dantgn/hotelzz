require 'rails_helper'

RSpec.shared_examples('when required parameters are missing') do
  let(:request_params) {}
  let(:expected_response) do
    {
      'error' => 'check_in is missing, check_out is missing, guests is missing'
    }
  end

  it 'returns an error' do
    subject

    expect(JSON.parse(response.body)).to eq(expected_response)
    expect(response.status).to eq(400)
  end
end

RSpec.describe HotelzzAPI::V1::Hotels, type: :request do
  subject { get request_url }

  describe 'GET /api/v1/hotels' do
    let(:request_url) { '/api/v1/hotels' }

    context 'when no hotels registered' do
      it 'returns empty list' do
        subject

        expect(JSON.parse(response.body)).to be_empty
        expect(response.status).to eq(200)
      end
    end

    context 'when hotels registered' do
      let!(:hotel) { Fabricate(:hotel, name: 'Best Hotel') }
      let(:expected_response) do
        [
          {
            'id' => hotel.id,
            'name' => hotel.name
          }
        ]
      end

      it 'returns list of hotels' do
        subject

        expect(JSON.parse(response.body)).to eq(expected_response)
        expect(response.status).to eq(200)
      end
    end
  end

  describe 'GET /api/v1/hotels/availability' do
    let(:hotel_availability_service) { instance_double('Hotels::CheckAvailability') }
    let(:request_url) { "/api/v1/hotels/availability?#{request_params}" }
    let(:request_params) {}
    let(:rent) { '1200.0 usd' }

    include_examples 'when required parameters are missing'

    context 'when required parameters are provided' do
      let(:request_params) { "check_in='2020/01/01'&check_out='2020/02/01'&guests=1" }

      context 'and hotels are available' do
        let!(:room_type) { Fabricate(:room_type) }
        let(:expected_response) do
          [
            {
              'hotelName' => room_type.hotel.name,
              'roomTypes' => availability_response
            }
          ]
        end
        let(:availability_response) do
          {
            'name' => room_type.name,
            'totalRooms' => room_type.number_of_rooms,
            'availableRooms' => room_type.number_of_rooms,
            'rent' => rent
          }
        end

        before do
          allow(Hotels::CheckAvailability).
            to receive(:new).
            and_return(hotel_availability_service)
          allow(hotel_availability_service).
            to receive(:call).
            and_return(availability_response)
        end

        it 'returns list of hotels availability' do
          subject

          expect(JSON.parse(response.body)).to eq(expected_response)
          expect(response.status).to eq(200)
        end
      end
    end
  end

  describe 'GET /api/v1/hotels/{hotel_id}/availability' do
    let(:hotel_availability_service) { instance_double('Hotels::CheckAvailability') }
    let(:request_url) { "/api/v1/hotels/#{room_type.hotel.id}/availability?#{request_params}" }
    let!(:room_type) { Fabricate(:room_type) }
    let(:rent) { '1200.0 usd' }

    include_examples 'when required parameters are missing'

    context 'when required parameters are provided' do
      let(:request_params) { "check_in='2020/01/01'&check_out='2020/02/01'&guests=1" }

      context 'and hotels are available' do
        let(:availability_response) do
          [
            {
              'name' => room_type.name,
              'totalRooms' => room_type.number_of_rooms,
              'availableRooms' => room_type.number_of_rooms,
              'rent' => rent
            }
          ]
        end

        before do
          allow(Hotels::CheckAvailability).
            to receive(:new).
            and_return(hotel_availability_service)
          allow(hotel_availability_service).
            to receive(:call).
            and_return(availability_response)
        end

        it 'returns list of hotels availability' do
          subject

          expect(JSON.parse(response.body)).to eq(availability_response)
          expect(response.status).to eq(200)
        end
      end
    end
  end
end
