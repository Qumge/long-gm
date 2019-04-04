class AddColumnLastUpdatedAtToProducts < ActiveRecord::Migration
  def change
    add_column :products, :last_updated_at, :datetime
  end
end
