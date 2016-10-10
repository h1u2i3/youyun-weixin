class RemoveHospitalToDoctors < ActiveRecord::Migration
  def up
    remove_column :doctors, :hospital, :string
  end

  def down
    add_column :doctors, :hospital, :string
  end
end
