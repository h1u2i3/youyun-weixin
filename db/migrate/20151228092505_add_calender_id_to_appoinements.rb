class AddCalenderIdToAppoinements < ActiveRecord::Migration
  def up
    add_column :appointments, :calender_id, :integer
  end

  def down
    remove_column :appointments, :calender_id
  end
end
