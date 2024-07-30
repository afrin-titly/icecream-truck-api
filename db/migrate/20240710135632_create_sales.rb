class CreateSales < ActiveRecord::Migration[7.0]
  def change
    create_table :sales do |t|
      t.references :item, null: false, foreign_key: true
      t.references :order, null: false, foreign_key: true
      t.integer :quantity, null: false
      t.decimal :total_price, precision: 10, scale: 2, null: false

      t.timestamps
    end
  end
end
