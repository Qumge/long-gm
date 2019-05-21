class AddColumnToMatter < ActiveRecord::Migration
  def change
    add_column :matters, :status, :string, default: :circulation
    add_column :matters, :countersign_user_id, :integer
    add_column :matters, :countersign_at, :datetime
  end
end
