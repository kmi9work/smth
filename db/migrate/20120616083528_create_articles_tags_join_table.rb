class CreateArticlesTagsJoinTable < ActiveRecord::Migration
  def up
    create_table :articles_tags, :id => false do |t|
      t.integer :tag_id
      t.integer :article_id
    end
  end

  def down
    drop_table :tags_articles
  end
end
