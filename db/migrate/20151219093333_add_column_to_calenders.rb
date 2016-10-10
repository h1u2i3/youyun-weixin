class AddColumnToCalenders < ActiveRecord::Migration
  def up
    remove_column :calenders, :calender_time
    add_column :calenders, :calender_start_time, :datetime
    add_column :calenders, :calender_end_time, :datetime
  end

  def down
    add_column :calenders, :calender_time, :string
    remove_column :calenders, :calender_start_time
    remove_column :calenders, :calender_end_time
  end
end
