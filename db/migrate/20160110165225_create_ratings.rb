class CreateRatings < ActiveRecord::Migration
  def change
    create_table :ratings do |t|
      t.integer :attitude
      t.integer :professional
      t.integer :communicate
      t.integer :statisfication

      t.timestamps null: false
    end
  end
end
