class CreateSkills < ActiveRecord::Migration
  def up
    create_table :skills do |t|
      t.string :name
      t.timestamps null: false
      t.index :name, unique: true
    end
  end

  def down
    drop_table :skills
  end
end
