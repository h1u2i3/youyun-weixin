class CreatePredoctors < ActiveRecord::Migration
  def change
    create_table :predoctors do |t|
      t.string :name
      t.string :openid

      t.timestamps null: false
    end
  end
end
