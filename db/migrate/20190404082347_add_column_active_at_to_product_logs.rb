class AddColumnActiveAtToProductLogs < ActiveRecord::Migration
  def change
    add_column :product_logs, :active_at, :datetime
  end
end
