class AddHotelManagerToHotel < ActiveRecord::Migration[5.2]
  def change
    add_reference :hotels, :hotel_manager, foreign_key: true
  end
end
