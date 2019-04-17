require 'rails_helper'

RSpec.describe RoomTypePrice, type: :model do
  it { should belong_to :room_type }

  it { should validate_presence_of :currency }
  it { should validate_presence_of :amount }
  it { should validate_presence_of :month }
end
