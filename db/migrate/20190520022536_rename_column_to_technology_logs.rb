class RenameColumnToTechnologyLogs < ActiveRecord::Migration
  def change
    rename_column :technology_logs, :product_id, :technology_id
    add_column :technologies, :active_at, :datetime
    add_column :technology_logs, :active_at, :datetime
    add_column :technology_logs, :apply_at, :datetime
  end
end
