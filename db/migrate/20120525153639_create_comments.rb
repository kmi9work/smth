class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.text :content
      t.integer :article_id
      t.references :parent
      t.integer :user_id

      t.timestamps
    end
  end
end
