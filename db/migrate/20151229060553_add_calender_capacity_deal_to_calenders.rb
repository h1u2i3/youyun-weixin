class AddCalenderCapacityDealToCalenders < ActiveRecord::Migration
  def up
    add_column :calenders, :calender_deal, :integer, default: 0
  end

  def down
    remove_column :calenders, :calender_deal
  end
end
