class CreatePayments < ActiveRecord::Migration[5.2]
  def change
    create_table :payments do |t|
      t.references  :booking, foreign_key: true
      t.string      :charge_id # in order to search in Stripe dashboard
      t.string      :status, null: false
      t.string      :info
      t.string      :currency, null: false
      t.decimal     :amount, precision: 8, scale: 2, null: false
      t.timestamps
    end
  end
end
