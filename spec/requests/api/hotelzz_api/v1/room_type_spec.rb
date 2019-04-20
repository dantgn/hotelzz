require 'rails_helper'

RSpec.describe HotelzzAPI::V1::RoomTypes, type: :request do
  subject { put request_url, params: request_params }

  describe 'PUT /api/v1/room_types/{room_type_id}/prices' do
    let(:request_url) { "/api/v1/room_types/#{room_type.id}/prices" }
    let(:request_params) do
      {
        month: month,
        amount: new_amount,
        currency: new_currency
      }
    end
    let(:hotel) { Fabricate(:hotel, hotel_manager: hotel_manager) }
    let(:hotel_manager) { Fabricate(:hotel_manager) }
    let(:room_type) { Fabricate(:room_type, hotel: hotel) }
    let!(:room_type_price) do
      Fabricate(:room_type_price,
                room_type: room_type,
                month: month,
                amount: amount,
                currency: currency)
    end
    let(:month) { 1 }
    let(:amount) { 1000.0 }
    let(:currency) { 'usd' }
    let(:new_amount) { 800.0 }
    let(:new_currency) { 'eur' }

    context 'when jwt authentication fails' do
      include_examples 'when jwt authentication fails'
    end

    context 'when authentication succeeds' do
      before do
        allow(Authentication::JsonWebToken).
          to receive(:decode).
          and_return(user_id: hotel_manager.id)
      end

      context 'and room_type does not belong to hotel_manager' do
        let(:room_type) { Fabricate(:room_type) }

        include_examples 'when jwt authentication fails'
      end

      context 'and room_type belongs to hotel_manager' do
        let(:expected_response) do
          {
            'id' => room_type_price.id,
            'room_type_id' => room_type.id,
            'amount' => new_amount.to_s,
            'currency' => new_currency
          }
        end
        it 'returns updated room_type_price details' do
          subject

          expect(JSON.parse(response.body)).to eq(expected_response)
          expect(response.status).to eq(200)
        end
      end
    end
  end
end
