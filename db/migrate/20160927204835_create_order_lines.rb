class CreateOrderLines < ActiveRecord::Migration[5.0]
  def change
    create_table :order_lines do |t|
    	t.references :order, index: true, foreign_key: true
		t.references :product, index: true, foreign_key: true
		t.references :fabric, index: true, foreign_key: true

		# Production
		t.boolean :std_size, default: true
		t.boolean :sep_fabric, default: true

		# Prices
		t.integer :quantity, default: 0
		t.decimal :unit_price, precision: 12, scale: 3
		t.decimal :fabric_price, precision: 12, scale: 3
		t.decimal :total_price, precision: 12, scale: 3

		t.timestamps null: false
    end
  end
end
