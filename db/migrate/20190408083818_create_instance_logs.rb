class CreateInstanceLogs < ActiveRecord::Migration
  def change
    create_table :instance_logs do |t|
      t.integer :instance_id
      t.string :file_name
      t.string :file_path
      t.integer :user_id
      t.string :status
      t.datetime :active_at
      t.timestamps null: false
    end
  end
end
