class AddCounterToUsers < ActiveRecord::Migration
  def up
    add_column :users, :appointments_count, :integer, default: 0
    add_column :users, :comments_count, :integer, default: 0
  end

  def down
    remove_column :users, :appointments_count
    remove_column :users, :comments_count
  end
end
