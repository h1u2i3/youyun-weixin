class AddAppointmentsCountToDoctors < ActiveRecord::Migration
  def up
    add_column :doctors, :appointments_count, :integer, default: 0
  end

  def down
    remove_column :doctors, :appointments_count
  end
end
