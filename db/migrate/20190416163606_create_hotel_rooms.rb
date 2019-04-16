class CreateHotelRooms < ActiveRecord::Migration[5.2]
  def change
    create_table :hotel_rooms do |t|
      t.references  :hotel, foreign_key: true
      t.references  :room_type, foreign_key: true
      t.integer     :number, null: false
      t.timestamps
    end
  end
end
