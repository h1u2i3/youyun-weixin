class AddClearedToAppointments < ActiveRecord::Migration
  def change
    add_column :appointments, :cleared, :boolean, default: false
  end
end
