class AddColumnToLogs < ActiveRecord::Migration
  def change
    add_column :product_logs, :apply_at, :datetime
    add_column :instance_logs, :apply_at, :datetime
  end
end
