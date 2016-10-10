class AddJoinTable < ActiveRecord::Migration
  def up
    create_join_table :doctors, :departments do |t|
      t.index :doctor_id
      t.index :department_id
    end
    create_join_table :doctors, :skills do |t|
      t.index :doctor_id
      t.index :skill_id
    end
  end

  def down
    drop_join_table :doctors, :departments
    drop_join_table :doctors, :skills
  end
end
