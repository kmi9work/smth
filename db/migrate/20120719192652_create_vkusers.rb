class CreateVkusers < ActiveRecord::Migration
  def change
    create_table :vkusers do |t|
      t.integer :vkid
      
      t.timestamps
    end
  end
end
