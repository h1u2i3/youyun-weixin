class AddColumnToPlaces < ActiveRecord::Migration
  def up
    add_belongs_to :places, :doctor
  end

  def down
    remove_belongs_to :places, :doctor
  end
end
