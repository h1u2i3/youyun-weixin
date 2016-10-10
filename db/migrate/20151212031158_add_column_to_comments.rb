class AddColumnToComments < ActiveRecord::Migration
  def up
    add_column :comments, :checked, :boolean, default: false
    add_column :comments, :approved, :boolean, default: true
    add_column :comments, :progress_score, :integer
    add_column :comments, :result_score, :integer
  end

  def down
    remove_column :comments, :checked
    remove_column :comments, :approved
    remove_column :comments, :progress_score
    remove_column :comments, :result_score
  end
end
