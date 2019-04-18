require 'rails_helper'

RSpec.describe Booking, type: :model do
  it { should belong_to :hotel }
  it { should belong_to :room_type }
  it { should belong_to :guest }
  it { should have_many :payments }

  it { should validate_presence_of :check_in }
  it { should validate_presence_of :check_out }
  it { should validate_inclusion_of(:status).in_array(Booking::STATUS) }
end
