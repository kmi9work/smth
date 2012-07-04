class Article < ActiveRecord::Base
  validates_presence_of :name, :content, :user

  attr_accessible :content, :name, :rating_id
 
  has_many :comments, :dependent => :destroy
  has_and_belongs_to_many :criterions
  has_one :rating, :dependent => :destroy
  belongs_to :user
  acts_as_taggable
  acts_as_taggable_on :other_tags
  
  # def Article.filter_articles filters
  #     filters.each do |filter|
  #       
  #     end
  #     $stdout.puts "1=============================="
  #     Article.joins(:criterions).where(['criterions.filter_id = ?', filter.id])
  #   end
  
  def Article.intersected_articles filters
    
  end
  
  def Article.filter_articles ids
    query = nil
    order_by = nil
    ids.each do |id, ob|
      if ob == "desc" or ob == "asc"
        order_by = ob 
      else
        order_by = "desc"
      end
      unless query
        query = "SELECT a.id
        from articles a
        inner join articles_criterions at on at.article_id = a.id
        inner join criterions t on t.id = at.criterion_id
        where t.filter_id = ?
        order by t.name #{order_by}"
      else
        query = "select a.id from articles a
        inner join articles_criterions at on at.article_id = a.id
        inner join criterions t on t.id = at.criterion_id
        where a.id IN (
        #{query}
        ) and t.filter_id = ?
        ORDER BY t.name #{order_by}"
      end
    end
    query = "select distinct a.* from articles a
    inner join articles_criterions at on at.article_id = a.id
    inner join criterions t on t.id = at.criterion_id
    where a.id IN ( #{query} )    
    order by name #{order_by}"
    Article.find_by_sql([query, *ids.map{|id| id[0] }])
  end
end
