class CreateUsersNotices < ActiveRecord::Migration
  def change
    create_table :users_notices do |t|
      t.integer :user_id
      t.integer :notice_id
      t.boolean :replied
      t.text :content
      t.timestamps null: false
    end
  end
end
