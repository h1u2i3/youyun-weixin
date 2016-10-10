class AddRelationsToRatings < ActiveRecord::Migration
  def change
    add_column :ratings, :user_id, :integer
    add_index :ratings, :user_id
    add_column :ratings, :doctor_id, :integer
    add_index :ratings, :doctor_id
    add_column :ratings, :appointment_id, :integer
    add_index :ratings, :appointment_id
  end
end
