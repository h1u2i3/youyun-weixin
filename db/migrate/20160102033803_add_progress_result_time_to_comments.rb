class AddProgressResultTimeToComments < ActiveRecord::Migration
  def up
    add_column :comments, :progress_time, :datetime
    add_column :comments, :result_time, :datetime
  end

  def down
    remove_column :comments, :progress_time
    remove_column :comments, :result_time
  end
end
