class ChangeColumnToProducts < ActiveRecord::Migration
  def change
    change_column :products, :active_at, :datetime
  end
end
