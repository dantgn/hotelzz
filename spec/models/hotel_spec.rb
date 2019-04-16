require 'rails_helper'

RSpec.describe Hotel, type: :model do
  it { should have_many :room_types }
  it { should have_many :hotel_rooms }

  it { should validate_presence_of :name }
end