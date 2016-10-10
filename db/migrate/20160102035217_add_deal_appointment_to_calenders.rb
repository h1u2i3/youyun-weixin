class AddDealAppointmentToCalenders < ActiveRecord::Migration
  def change
    add_column :calenders, :deal_appointment, :integer, default: 0
  end

  def down
    remove_column :calenders, :deal_appointment
  end
end
