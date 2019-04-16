require 'rails_helper'

RSpec.describe HotelRoom, type: :model do
  it { should belong_to :hotel }
  it { should belong_to :room_type }

  it { should validate_presence_of :number }
end
