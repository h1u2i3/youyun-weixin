class AddIndexToCalenders < ActiveRecord::Migration
  def up
    add_index :calenders, :calender_day
  end

  def down
    remove_index :calenders, :calender_day
  end
end
