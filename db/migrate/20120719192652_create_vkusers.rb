class CreateVkusers < ActiveRecord::Migration
  def change
    create_table :vkusers, :primary_key => :vkid do |t|
      t.integer :vkid
      t.boolean :sent, :default => false
      t.datetime :created_at
    end
  end
end
