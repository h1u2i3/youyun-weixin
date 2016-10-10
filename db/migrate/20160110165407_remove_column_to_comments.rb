class RemoveColumnToComments < ActiveRecord::Migration
  def change
    remove_column :comments, :progress
    remove_column :comments, :progress_score
    remove_column :comments, :result_score
    remove_column :comments, :result
  end
end
