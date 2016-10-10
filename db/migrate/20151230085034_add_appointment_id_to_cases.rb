class AddAppointmentIdToCases < ActiveRecord::Migration
  def up
    add_column :cases, :appointment_id, :integer
  end

  def down
    remove_column :cases, :appointment_id
  end
end
