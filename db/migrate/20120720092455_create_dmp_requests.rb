class CreateDmpRequests < ActiveRecord::Migration
  def change
    create_table :dmp_requests do |t|
      t.string :name
      t.text :content
      t.integer :offset, :default => 0
      t.integer :start_offset, :default => 0
      t.string :q
      t.string :country
      t.string :city
      t.string :university
      t.integer :uni_year
      t.string :school
      t.integer :school_year
      t.integer :age_from
      t.integer :age_to
      t.integer :online
      t.integer :photo
      t.integer :sex
      t.integer :group
      t.string :query, :limit => 1024
      t.integer :status #semeinoe polojenie
      t.timestamps
    end
  end
end
