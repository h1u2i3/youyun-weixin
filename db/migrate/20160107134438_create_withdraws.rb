class CreateWithdraws < ActiveRecord::Migration
  def change
    create_table :withdraws do |t|
      t.integer :doctor_id
      t.float :number
      t.string :operator

      t.timestamps null: false
    end
  end
end
