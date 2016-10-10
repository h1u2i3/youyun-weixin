class AddBelongsToDoctor < ActiveRecord::Migration
  def up
    add_belongs_to :calenders, :doctor
  end

  def down
    remove_belongs_to :calender, :doctor
  end
end
