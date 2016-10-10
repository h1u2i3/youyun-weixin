class RemoveIndexOpenidToDoctors < ActiveRecord::Migration
  def change
    remove_index :doctors, :openid
  end
end
