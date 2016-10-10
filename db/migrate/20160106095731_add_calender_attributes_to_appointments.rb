class AddCalenderAttributesToAppointments < ActiveRecord::Migration
  def change
    add_column :appointments, :calender_time, :string
    add_column :appointments, :calender_place, :string
    add_column :appointments, :calender_day, :string
  end

  def down
    remove_column :appointments, :calender_time
    remove_column :appointments, :calender_place
    remove_column :appointments, :calender_day
  end
end
