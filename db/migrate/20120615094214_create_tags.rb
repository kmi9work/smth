class CreateTags < ActiveRecord::Migration
  def change
    create_table :tags do |t|
      t.integer :tgroup_id
      t.string :name
    end
  end
end
