class AddCellphoneToAppointments < ActiveRecord::Migration
  def up
    add_column :appointments, :cellphone, :string
    add_column :appointments, :payed, :boolean, default: false
  end

  def down
    remove_column :appointments, :cellphone
    remove_column :appointments, :payed
  end
end
