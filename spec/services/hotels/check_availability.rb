require 'rails_helper'

RSpec.describe Hotels::CheckAvailability do
  let(:service) do
    described_class.new(hotel: hotel, check_in: check_in, check_out: check_out, guests: guests)
  end
  let(:hotel) { Fabricate(:hotel) }
  let!(:room_type1) do
    Fabricate(:room_type, name: 'single bed room', hotel: hotel, occupancy_limit: 1, number_of_rooms: 2)
  end
  let!(:room_type2) do
    Fabricate(:room_type, name: 'king-size bed room', hotel: hotel, occupancy_limit: 2, number_of_rooms: 4)
  end
  let(:check_in) { '01/10/2019'.to_date }
  let(:check_out) { '31/10/2019'.to_date }
  let(:guests) { 1 }
  let(:all_rooms_free) do
    {
      room_type1.id => room_type1.number_of_rooms,
      room_type2.id => room_type2.number_of_rooms
    }
  end

  describe '#call' do
    subject { service.call }

    context 'error handling' do
      context 'when check_in date is in the past' do
        let(:service) do
          described_class.new(hotel: hotel, check_in: 1.day.ago, check_out: check_out, guests: guests)
        end

        it { expect { subject }.to raise_error(Hotels::Errors::AvailabilityInvalidDates) }
      end

      context 'when check_in date is later than check_out' do
        let(:service) do
          described_class.new(hotel: hotel, check_in: check_out, check_out: check_in, guests: guests)
        end

        it { expect { subject }.to raise_error(Hotels::Errors::AvailabilityInvalidDates) }
      end
    end

    context 'when all rooms are available' do
      let(:expected_response) { all_rooms_free }

      it { expect(subject).to eq(expected_response) }
    end

    context 'when no rooms available for requested number of guests' do
      let(:expected_response) { {} }
      let(:guests) { [room_type1.number_of_rooms, room_type1.number_of_rooms].max + 1 }

      it { expect(subject).to eq(expected_response) }
    end

    context 'when there are bookings for rooms within the same dates of the request' do
      let!(:booking1) do
        Fabricate(:booking, hotel: hotel, room_type: room_type1, check_in: check_in, check_out: check_out)
      end
      let!(:booking2) do
        Fabricate(:booking, hotel: hotel, room_type: room_type2, check_in: (check_in + 1.week), check_out: (check_out + 1.week))
      end
      let(:expected_response) do
        {
          room_type1.id => room_type1.number_of_rooms - 1,
          room_type2.id => room_type2.number_of_rooms - 1
        }
      end

      it 'only displays available rooms' do
        expect(subject).to eq(expected_response)
      end
    end

    context 'when there is a booking for another dates' do
      let(:expected_response) { all_rooms_free }

      it 'offers all the rooms' do
        expect(subject).to eq(expected_response)
      end
    end
  end
end
