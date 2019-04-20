require 'rails_helper'

RSpec.describe RoomType, type: :model do
  it { should belong_to :hotel }
  it { should have_many :bookings }
  it { should have_many :room_type_prices }

  it { should validate_presence_of :name }
  it { should validate_presence_of :occupancy_limit }
  it { should validate_presence_of :number_of_rooms }

  describe '#available?' do
    subject { room_type.available?(check_in: check_in, check_out: check_out) }
    let(:room_type) { Fabricate(:room_type, number_of_rooms: number_of_rooms) }
    let(:check_in) { '2020/01/01'.to_date }
    let(:check_out) { '2020/02/01'.to_date }
    let(:number_of_rooms) { 1 }

    context 'when no bookings are made for selected dates' do
      it { expect(subject).to eq(true) }
    end

    context 'when all available rooms are booked for selected dates' do
      let!(:booking) do
        Fabricate(:booking, room_type: room_type, check_in: check_in, check_out: check_out)
      end

      it { expect(subject).to eq(false) }
    end

    context 'when there are bookings for selected dates but still free rooms' do
      let(:number_of_rooms) { 2 }
      let!(:booking) do
        Fabricate(:booking, room_type: room_type, check_in: check_in, check_out: check_out)
      end

      it { expect(subject).to eq(true) }
    end

    context 'when a booking finishes on selected check in date' do
      subject { room_type.available?(check_in: check_in, check_out: check_out) }
      let!(:booking) do
        Fabricate(:booking, room_type: room_type, check_in: check_out, check_out: (check_out + 1.month))
      end

      it { expect(subject).to eq(true) }
    end
  end
end
