class CreateRoomTypePrices < ActiveRecord::Migration[5.2]
  def change
    create_table :room_type_prices do |t|
      t.references  :room_type, foreign_key: true
      t.string      :currency, default: 'usd', null: false
      t.decimal     :amount, precision: 8, scale: 2, null: false
      t.integer     :month, null: false
      t.timestamps
    end
  end
end
