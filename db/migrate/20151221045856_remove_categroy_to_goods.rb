class RemoveCategroyToGoods < ActiveRecord::Migration
  def up
    remove_belongs_to :goods, :category
  end

  def down
    add_belongs_to :goods, :category
  end
end
