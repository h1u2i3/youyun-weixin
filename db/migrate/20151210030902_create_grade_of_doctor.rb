class CreateGradeOfDoctor < ActiveRecord::Migration
  def up
    create_table :grades do |t|
      t.string :name
      t.integer :doctors_count, default: 0

      t.timestamps null: false
    end
  end

  def down
    drop_table :grades
  end
end
