class AddRefundNoToAppointments < ActiveRecord::Migration
  def change
    add_column :appointments, :refunded, :boolean, default: false
    add_column :appointments, :refund_no, :string
  end
end
