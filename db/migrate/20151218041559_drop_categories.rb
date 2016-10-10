class DropCategories < ActiveRecord::Migration
  def up
    drop_table :categories

    create_table :tags do |t|
      t.string :name

      t.timestamps null: false
    end

    create_join_table :tags, :goods
  end

  def down
    create_table :categories do |t|
      t.string :name

      t.timestamps null: false
    end

    drop_table :tags
    drop_join_table :tags, :goods
  end
end
