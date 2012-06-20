class CreateTgroups < ActiveRecord::Migration
  def change
    create_table :tgroups do |t|
      t.string :name

      t.timestamps
    end
  end
end
