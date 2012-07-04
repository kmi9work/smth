class CreateCriterions < ActiveRecord::Migration
  def change
    create_table :criterions do |t|
      t.integer :filter_id
      t.string :name
    end
  end
end
