class CreateOrders < ActiveRecord::Migration[7.0]
  def change
    create_table :orders do |t|
      t.string :order_number, null: false
      t.references :user, null: false, foreign_key: true
      t.decimal :total_amount, precision: 10, scale: 2, null: false, default: 0.0
      t.timestamps
    end
  end
end
