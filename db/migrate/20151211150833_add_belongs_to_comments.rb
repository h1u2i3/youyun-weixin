class AddBelongsToComments < ActiveRecord::Migration
  def up
    add_belongs_to :comments, :user
    add_belongs_to :comments, :doctor
  end

  def down
    remove_belongs_to :comments, :user
    remove_belongs_to :comments, :doctor
  end
end
