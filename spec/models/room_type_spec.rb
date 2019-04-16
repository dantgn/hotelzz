require 'rails_helper'

RSpec.describe RoomType, type: :model do
  it { should belong_to :hotel }
  it { should have_many :hotel_rooms }  

  it { should validate_presence_of :name }
  it { should validate_presence_of :occupancy_limit }
end
