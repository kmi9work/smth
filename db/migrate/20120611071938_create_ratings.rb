class CreateRatings < ActiveRecord::Migration
  def change
    create_table :ratings do |t|
      t.integer :count
      t.integer :article_id

      t.timestamps
    end
  end
end
