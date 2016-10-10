class CreateIncomes < ActiveRecord::Migration
  def change
    create_table :incomes do |t|
      t.integer :doctor_id
      t.float :number
      t.string :user_openid
      t.string :appointment_no

      t.timestamps null: false
    end
  end
end
