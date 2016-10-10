class AddExtraPlacesToAppointments < ActiveRecord::Migration
  def change
    add_column :appointments, :service_name, :string
    add_column :appointments, :service_description, :text
    add_column :appointments, :service_price, :float
  end

  def down
    remove_column :appointments, :service_name
    remove_column :appointments, :service_description
    remove_column :appointments, :service_price
  end
end
