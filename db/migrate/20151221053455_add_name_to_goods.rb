class AddNameToGoods < ActiveRecord::Migration
  def up
    add_column :goods, :name, :string
    add_index :goods, :name
    add_column :goods, :description, :text
    add_column :goods, :published, :boolean, default: false
  end

  def down
    remove_index :goods, :name
    remove_column :goods, :name
    remove_column :goods, :description
    remove_column :goods, :published
  end
end
