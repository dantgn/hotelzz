class CreateBookings < ActiveRecord::Migration[5.2]
  def change
    create_table :bookings do |t|
      t.references  :hotel, foreign_key: true
      t.references  :room_type, foreign_key: true
      t.references  :guest, foreign_key: true
      t.date        :check_in, null: false
      t.date        :check_out, null: false
      t.string      :status, null: false, default: 'unpaid'
      t.timestamps
    end
  end
end
