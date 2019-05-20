class AddColumnToTechnologies < ActiveRecord::Migration
  def change
    add_column :technologies, :last_user_id, :integer
    add_column :technologies, :file_user_id, :integer
  end
end
