require 'rails_helper'

RSpec.describe Hotels::CalculateRent do
  let(:service) do
    described_class.new(room_type: room_type, check_in: check_in, check_out: check_out, currency: currency)
  end
  let!(:room_type) do
    Fabricate(:room_type, name: 'single bed room', occupancy_limit: 1, number_of_rooms: 2)
  end
  let(:check_in) { '01/01/2019'.to_date }
  let(:check_out) { '01/02/2019'.to_date }
  let(:currency) { 'usd' }

  before do
    12.times do |index|
      Fabricate(:room_type_price, month: index + 1, room_type: room_type, amount: 1000, currency: currency)
    end
  end

  describe '#call' do
    subject { service.call }

    context 'when period is one full month' do
      it 'returns total rent price per requested month' do
        expect(subject).to eq('1000.0 usd')
      end
    end

    context 'when more than one month involved' do
      let(:check_out) { '01/03/2019'.to_date }

      it 'returns total rent price per all months' do
        expect(subject).to eq('2000.0 usd')
      end
    end
  end

  describe '#average' do
    # average is monthly_rent(1000)/days_rent(31) => 32.26
    subject { service.average }

    it 'returns average price per night' do
      expect(subject).to eq('32.26 usd/night')
    end

    context 'when currency is eur' do
      let(:currency) { 'eur' }

      it 'returns average price per night with currency in eur' do
        expect(subject).to eq('32.26 eur/night')
      end
    end

    context 'when rents diverge every month' do
      # average is monthly_rent(1000 + 1200)/days_rent(31 + 28) => 37.29
      let(:check_out) { '01/03/2019'.to_date }

      before do
        room_type.room_type_prices.find_by(month: 2).update(amount: 1200)
      end

      it 'returns average price per night from all rates' do
        expect(subject).to eq('37.29 usd/night')
      end
    end

    describe '#amount' do
      subject { service.amount }

      it 'returns amount without currency' do
        expect(subject).to eq(1000.0)
      end
    end
  end
end
