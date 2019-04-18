class Payment < ApplicationRecord
  belongs_to :booking

  validates :status, presence: true
end
