class AlterTableCalenders < ActiveRecord::Migration
  def up
    remove_column :calenders, :week
    remove_column :calenders, :plan
    remove_column :calenders, :place

    add_column :calenders, :calender_day, :string
    add_column :calenders, :calender_place, :string
    add_column :calenders, :calender_time, :string
    add_column :calenders, :calender_capacity, :integer
  end

  def down
    add_column :calenders, :week, :string
    add_column :calenders, :plan, :string
    add_column :calenders, :place, :string

    remove_column :calenders, :calender_day
    remove_column :calenders, :calender_place
    remove_column :calenders, :calender_time
    remove_column :calenders, :calender_capacity
  end
end
