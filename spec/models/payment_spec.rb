require 'rails_helper'

RSpec.describe Payment, type: :model do
  it { should belong_to :booking }

  it { should validate_presence_of :status }
end
