class Article < ActiveRecord::Base
  validates_presence_of :name, :content, :user

  attr_accessible :content, :name, :rating_id
 
  has_many :comments, :dependent => :destroy
  
  has_and_belongs_to_many :tags
  
  has_one :rating, :dependent => :destroy
  
  belongs_to :user
  
  # def Article.tgroup_articles tgroups
  #     tgroups.each do |tgroup|
  #       
  #     end
  #     $stdout.puts "1=============================="
  #     Article.joins(:tags).where(['tags.tgroup_id = ?', tgroup.id])
  #   end
  
  def Article.tgroup_articles ids, order_by
    query = nil
    as = "a"
    order_by = "desc" unless order_by.to_s == "desc" or order_by.to_s == "asc"
    ids.each do |id|
      unless query
        query = "SELECT DISTINCT \"articles\".* FROM \"articles\"
        INNER JOIN \"articles_tags\" ON \"articles_tags\".\"article_id\" = \"articles\".\"id\" 
        INNER JOIN \"tags\" ON \"tags\".\"id\" = \"articles_tags\".\"tag_id\" 
        WHERE \"tags\".\"tgroup_id\" = ?"
      else
        query = "Select DISTINCT \"#{as}\".* FROM (
        #{query}
        ) as \"#{as}\" INNER JOIN \"articles_tags\" ON \"articles_tags\".\"article_id\" = \"#{as}\".\"id\" 
        INNER JOIN \"tags\" ON \"tags\".\"id\" = \"articles_tags\".\"tag_id\" 
        WHERE tags.tgroup_id = ?"
        as.next!
      end
    end
    query += " ORDER BY \"tags\".\"name\" #{order_by.to_s}"
    Article.find_by_sql([query, *ids])
  end
  
  def Article.tga id1, id2
    Article.find_by_sql(['Select DISTINCT "a".* FROM (
      SELECT "articles".* FROM "articles"
      INNER JOIN "articles_tags" ON "articles_tags"."article_id" = "articles"."id" 
      INNER JOIN "tags" ON "tags"."id" = "articles_tags"."tag_id" 
      WHERE tags.tgroup_id = ?
    ) as a INNER JOIN "articles_tags" ON "articles_tags"."article_id" = "a"."id" 
    INNER JOIN "tags" ON "tags"."id" = "articles_tags"."tag_id" 
    WHERE tags.tgroup_id = ?', id1, id2])
  end
  
  def Article.tga1 id
    Article.find_by_sql(['SELECT DISTINCT "articles".* FROM "articles"
    INNER JOIN "articles_tags" ON "articles_tags"."article_id" = "articles"."id" 
    INNER JOIN "tags" ON "tags"."id" = "articles_tags"."tag_id" 
    WHERE tags.tgroup_id = ?', id])
  end
  def tgroup_articles tgroup
    $stdout.puts "2==============================="
    self.joins(:tags).where(['tags.tgroup_id = ?', tgroup.id])
  end
  
  def Article.tgroup_articles_sorted tgroup, order
    o = order.to_s
    return nil unless o == 'desc' or o == 'asc'
    my_articles = []
    tgroup.tags.order("name #{o}").each do |tag|
      my_articles += tag.articles
    end
    my_articles
  end
end
