class AddInitializeModel < ActiveRecord::Migration
  def up
    create_table :admins do |t|
      t.string :name
      t.string :password_digest
      t.string :level
      t.timestamps null: false

      t.index :name, unique: true
    end

    create_table :doctors do |t|
      t.string :name
      t.string :openid
      t.string :hospital
      t.text :description
      t.timestamps null: false

      t.index :name
      t.index :openid, unique: true
    end

    create_table :users do |t|
      t.string :openid
      t.string :name
      t.timestamps null: false

      t.index :openid, unique: true
    end

    create_table :categories do |t|
      t.string :name
      t.text :discription
      t.timestamps null: false
    end

    create_table :goods do |t|
      t.belongs_to :doctor
      t.belongs_to :category
      t.float :price
      t.timestamps null: false
    end

    create_table :calenders do |t|
      t.string :week
      t.string :plan
      t.string :place
      t.timestamps null: false
    end

    create_table :appointments do |t|
      t.string :appoint_unique_number
      t.belongs_to :user
      t.belongs_to :doctor
      t.belongs_to :good
      t.boolean :finished, default: false
      t.timestamps null: false
    end

    create_table :cases do |t|
      t.string :symptom
      t.string :check
      t.timestamps null: false
    end

    create_table :comments do |t|
      t.belongs_to :appointment
      t.string :progress
      t.string :result
      t.timestamps null: false
    end

    create_table :attach_images do |t|
      t.belongs_to :case
      t.string :image
      t.timestamps null: false
    end
  end

  def down
    drop_table :admins
    drop_table :doctors
    drop_table :users
    drop_table :categories
    drop_table :goods
    drop_table :calenders
    drop_table :appointments
    drop_table :cases
    drop_table :comments
    drop_table :attach_images
  end
end
