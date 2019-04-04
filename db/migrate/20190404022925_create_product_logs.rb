class CreateProductLogs < ActiveRecord::Migration
  def change
    create_table :product_logs do |t|
      t.integer :product_id
      t.string :file_name
      t.string :file_path
      t.integer :user_id
      t.string :status
      t.timestamps null: false
    end
  end
end
