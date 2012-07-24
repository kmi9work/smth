class CreateDmpRequests < ActiveRecord::Migration
  def change
    create_table :dmp_requests do |t|
      t.string :name
      t.string :content
      t.integer :offset, :default => 0
      t.string :q
      t.string :country
      t.string :city
      t.string :university
      t.string :school
      t.timestamps
    end
  end
end
