class CreateInstanceCategories < ActiveRecord::Migration
  def change
    create_table :instance_categories do |t|
      t.string :name
      t.text :desc
      t.timestamps null: false
    end
  end
end
