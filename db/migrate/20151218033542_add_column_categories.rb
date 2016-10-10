class AddColumnCategories < ActiveRecord::Migration
  def up
    remove_column :categories, :discription
  end

  def down
    add_column :categories, :discription, :string
  end
end
