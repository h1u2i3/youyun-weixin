class AddPublishedToDoctors < ActiveRecord::Migration
  def up
    add_column :doctors, :published, :boolean, default: false
  end

  def down
    remove_column :doctors, :published
  end
end
