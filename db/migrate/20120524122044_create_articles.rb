class CreateArticles < ActiveRecord::Migration
  def change
    create_table :articles do |t|
      t.string :name
      t.text :content
      t.integer :rating_id
      t.integer :user_id
      
      t.date :last_comment_at
      t.date :original_at
      t.timestamps
    end
  end
end
