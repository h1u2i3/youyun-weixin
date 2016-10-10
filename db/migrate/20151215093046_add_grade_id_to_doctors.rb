class AddGradeIdToDoctors < ActiveRecord::Migration
  def up
    add_belongs_to :doctors, :grade
  end

  def down
    remove_belongs_to :doctors, :grade
  end
end
