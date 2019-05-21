class AddColumnToInstances < ActiveRecord::Migration
  def change
    add_column :instances, :instance_category_id, :integer
  end
end
