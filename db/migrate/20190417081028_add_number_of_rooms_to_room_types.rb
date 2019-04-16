class AddNumberOfRoomsToRoomTypes < ActiveRecord::Migration[5.2]
  def change
    add_column :room_types, :number_of_rooms, :integer, default: 1, null: false
  end
end
