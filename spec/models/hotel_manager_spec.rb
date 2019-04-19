require 'rails_helper'

RSpec.describe HotelManager, type: :model do
  it { should have_many :hotels }

  it { should validate_presence_of :email }
  it { should validate_presence_of :password }
end
