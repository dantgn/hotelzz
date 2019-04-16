require 'rails_helper'

RSpec.describe RoomType, type: :model do
  it { should belong_to :hotel }
  it { should have_many :hotel_rooms }
  it { should have_many :bookings }

  it { should validate_presence_of :name }
  it { should validate_presence_of :occupancy_limit }
  it { should validate_presence_of :number_of_rooms }
end
