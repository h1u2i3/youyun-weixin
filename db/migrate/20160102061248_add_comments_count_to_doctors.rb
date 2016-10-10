class AddCommentsCountToDoctors < ActiveRecord::Migration
  def change
    add_column :doctors, :comments_count, :integer, default: 0
  end

  def down
    add_column :doctors, :comments_count
  end
end
