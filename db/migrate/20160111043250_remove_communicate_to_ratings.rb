class RemoveCommunicateToRatings < ActiveRecord::Migration
  def change
    remove_column :ratings, :communicate
  end
end
