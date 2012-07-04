class CreateArticlesCriterionsJoinTable < ActiveRecord::Migration
  def up
    create_table :articles_criterions, :id => false do |t|
      t.integer :criterion_id
      t.integer :article_id
    end
  end

  def down
    drop_table :articles_criterions
  end
end
