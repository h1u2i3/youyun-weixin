class AddCanceledToAppointments < ActiveRecord::Migration
  def up
    add_column :appointments, :canceled, :boolean, default: false
  end

  def down
    remove_column :appointments, :canceled
  end
end
