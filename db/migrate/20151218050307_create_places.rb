class CreatePlaces < ActiveRecord::Migration
  def up
    create_table :places do |t|
      t.string :address

      t.timestamps null: false
    end
  end

  def down
    drop_table :places
  end
end
