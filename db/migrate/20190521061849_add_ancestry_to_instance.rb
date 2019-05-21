class AddAncestryToInstance < ActiveRecord::Migration
  def change
    add_column :instances, :ancestry, :string
    add_index :instances, :ancestry
  end
end
