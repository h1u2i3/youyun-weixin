class AddCalenderEndTimeToAppointments < ActiveRecord::Migration
  def change
    add_column :appointments, :calender_datetime, :datetime
  end
end
