class CreateNotices < ActiveRecord::Migration
  def change
    create_table :notices do |t|
      t.integer :model_id
      t.string :model_type
      t.text :content
      t.boolean :need_reply
      t.timestamps null: false
    end
  end
end
