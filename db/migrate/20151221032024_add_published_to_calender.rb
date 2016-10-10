class AddPublishedToCalender < ActiveRecord::Migration
  def up
    add_column :calenders, :published, :boolean, default: false
  end

  def down
    remove_column :calenders, :published
  end
end
