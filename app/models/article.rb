class Article < ActiveRecord::Base
  validates_presence_of :name, :content, :user

  attr_accessible :content, :name, :rating_id
 
  has_many :comments, :dependent => :destroy
  has_and_belongs_to_many :criterions
  has_one :rating, :dependent => :destroy
  belongs_to :user
  acts_as_taggable
  acts_as_taggable_on :other_tags
  DATE_TYPES = ['created_at', 'updated_at', 'last_comment_at', 'original_at']
  # def Article.filter_articles filters
  #     filters.each do |filter|
  #       
  #     end
  #     $stdout.puts "1=============================="
  #     Article.joins(:criterions).where(['criterions.filter_id = ?', filter.id])
  #   end
  
  # def Article.intersected_articles
  #     query = "
  #     select distinct on (a.id) a.*, cc.name as cname from articles a
  #     inner join articles_criterions ac on a.id = ac.article_id 
  #     inner join criterions c on ac.criterion_id = c.id
  #     full outer join criterions cc on ac.criterion_id = cc.id and cc.filter_id = 1
  #     full outer join criterions ccc on ac.criterion_id = ccc.id and ccc.filter_id = 4
  #     where a.id in (
  #     select a.id from articles a 
  #     inner join articles_criterions ac on a.id = ac.article_id 
  #     inner join criterions c on ac.criterion_id = c.id
  #     where c.filter_id = 1
  #     INTERSECT
  #     select a.id from articles a 
  #     inner join articles_criterions ac on a.id = ac.article_id 
  #     inner join criterions c on ac.criterion_id = c.id
  #     where c.filter_id = 5
  #     )
  #     group by a.id
  #     order by cc.name desc;"
  #     Article.find_by_sql(query)
  #   end
  
  # def Article.filter_articles ids
  #    query = nil
  #    order_by = nil
  #    ids.each do |id, ob|
  #      if ob == "desc" or ob == "asc"
  #        order_by = ob 
  #      else
  #        order_by = "desc"
  #      end
  #      unless query
  #        query = "SELECT a.id
  #        from articles a
  #        inner join articles_criterions at on at.article_id = a.id
  #        inner join criterions t on t.id = at.criterion_id
  #        where t.filter_id = ?
  #        order by t.name #{order_by}"
  #      else
  #        query = "select a.id from articles a
  #        inner join articles_criterions at on at.article_id = a.id
  #        inner join criterions t on t.id = at.criterion_id
  #        where a.id IN (
  #        #{query}
  #        ) and t.filter_id = ?
  #        ORDER BY t.name #{order_by}"
  #      end
  #    end
  #    query = "select distinct a.* from articles a
  #    inner join articles_criterions at on at.article_id = a.id
  #    inner join criterions t on t.id = at.criterion_id
  #    where a.id IN ( #{query} )    
  #    order by name #{order_by}"
  #    Article.find_by_sql([query, *ids.map{|id| id[0] }])
  #  end
  
  # def Article.intersect_criterions criterion_ids
  #   query = Array.new(criterion_ids.size,"select a.* from articles a 
  #   inner join articles_criterions ac on a.id = ac.article_id 
  #   where ac.criterion_id = ?").join(" INTERSECT ")
  #   Article.find_by_sql([query, *criterion_ids])
  # end
  # 
  # def Article.criterions_sort_by_filter filter_sorting, criterion_ids
  #   Article.sort_sql_by_filter(Article.intersect_criterions_sql(criterion_ids), filter_sorting[0], filter_sorting[1])
  # end
  # def Article.all_sort_by_filter filter_sorting
  #   Article.sort_sql_by_filter('SELECT "articles".* FROM "articles"', filter_sorting[0], filter_sorting[1])
  # end
  
  def Article.filter_by criterion_ids, filter_sorting, date_sorting
    query = "SELECT articles.id from articles"
    query = intersect_criterions_sql(criterion_ids) if criterion_ids and !criterion_ids.empty?
    if filter_sorting
      query = sort_sql_by_filter(query, filter_sorting[0], filter_sorting[1])
      if date_sorting
        query += ", #{ActiveRecord::Base.connection.quote(date_sorting[0])} #{ActiveRecord::Base.connection.quote(date_sorting[1])}" 
      end
    else
      if date_sorting
        query = "select articles.* from articles where articles.id in (
        #{query}
        ) 
        order by #{ActiveRecord::Base.connection.quote(date_sorting[0])} #{ActiveRecord::Base.connection.quote(date_sorting[1])}"
      else
        query = "select articles.* from articles where articles.id in (
        #{query}
        )"
      end
    end
    Article.find_by_sql(query)
  end 
private
  def Article.intersect_criterions_sql criterion_ids
    criterion_ids.map{|id| "select a.id from articles a 
    inner join articles_criterions ac on a.id = ac.article_id 
    where ac.criterion_id = #{ActiveRecord::Base.connection.quote(id)}"}.join(" INTERSECT ")
  end
  
  def Article.sort_sql_by_filter sql, filter, order = "desc"
    order = "desc" unless order == "asc"
    query = "
    select distinct a.*, c.name as cname from articles a
    INNER JOIN articles_criterions ac ON ac.article_id = a.id 
    INNER JOIN criterions c ON c.id = ac.criterion_id
    where a.id in (
    #{sql}
    ) and c.filter_id = #{ActiveRecord::Base.connection.quote(filter)} 
    order by c.name #{order}
    "
  end
=begin
if session[:criterion_ids] and !session[:criterion_ids].empty?
  if session[:filter_sorting]
    if session[:date_sorting]
      @articles = Article.criterions_sort_by_filter_and_date(session[:filter_sorting], session[:criterion_ids], session[:date_sorting])
    else
      @articles = Article.criterions_sort_by_filter(session[:filter_sorting], session[:criterion_ids])
    end
  else
    if session[:date_sorting]
      @articles = Article.intersect_criterions_sort_by_date(session[:criterion_ids])
    else
      @articles = Article.intersect_criterions(session[:criterion_ids])
    end
  end
else
  session[:criterion_ids] = []
  if session[:filter_sorting]
    if session[:date_sorting]
      @articles = Article.all_sort_by_filter_and_date(session[:filter_sorting], session[:date_sorting])
    else
      @articles = Article.all_sort_by_filter(session[:filter_sorting])
    end
  else
    if session[:date_sorting]
      @articles = Article.all_sort_by_date(session[:date_sorting])
    else
      @articles = Article.all
    end
  end
end
=end
end
