class CreateDepartmentsOfDoctor < ActiveRecord::Migration
  def up
    create_table :departments do |t|
      t.string :name
      t.integer :doctors_count, default: 0

      t.timestamps null: false
    end
  end

  def down
    drop_table :departments
  end
end
