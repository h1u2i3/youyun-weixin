class AddRefundingToAppointments < ActiveRecord::Migration
  def change
    add_column :appointments, :refunding, :boolean, default: false
  end

  def down
    remove_column :appointments, :refunding
  end
end
