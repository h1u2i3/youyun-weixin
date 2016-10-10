class AddCounterCacheToDoctors < ActiveRecord::Migration
  def change
    add_column :doctors, :ratings_count, :integer, default: 0
  end
end
