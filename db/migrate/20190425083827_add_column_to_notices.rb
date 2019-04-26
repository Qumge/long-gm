class AddColumnToNotices < ActiveRecord::Migration
  def change
    add_column :notices, :title, :string
    add_column :notices, :user_id, :integer
  end
end
