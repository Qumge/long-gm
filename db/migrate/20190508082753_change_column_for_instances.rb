class ChangeColumnForInstances < ActiveRecord::Migration
  def change
    change_column :instances, :file_user_id, :integer
  end
end
