class AddColumnToUsers < ActiveRecord::Migration
  def up
    add_column :users, :subscribe, :boolean
    add_column :users, :avatar, :string
  end

  def down
    remove_column :users, :subscribe
    remove_column :users, :avatar
  end
end
