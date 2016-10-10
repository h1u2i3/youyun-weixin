class RemoveTimeColumnToComments < ActiveRecord::Migration
  def change
    remove_column :comments, :progress_time, :string
    remove_column :comments, :result_time, :string
  end
end
