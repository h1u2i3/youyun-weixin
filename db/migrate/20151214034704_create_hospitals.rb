class CreateHospitals < ActiveRecord::Migration
  def up
    create_table :hospitals do |t|
      t.string :name
      t.integer :doctors_count, default: 0

      t.timestamps nill: false
    end

    add_belongs_to :doctors, :hospital
  end

  def down
    drop_table :hospitals

    remove_belongs_to :doctors, :hospital
  end
end
