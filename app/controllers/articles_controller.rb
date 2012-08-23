class ArticlesController < ApplicationController
  load_resource :only => [:show, :edit, :update, :destroy]
  # authorize_resource
  before_filter :find_filters
  def index
    #Show standart filters and criterions or search.
    # if session[:criterions] or session[:sortings]
    #       @articles = Article.filter_by(session[:criterions], session[:sortings])
    #     else
    #       session[:criterions] = [[2,3], [5, 6]]
    #       session[:sortings] = [["rating", "desc"]]
    #       @articles = Article.filter_by(session[:criterions], session[:sortings])     
    #     end
    @selected_filters = []
    @articles = []
  end
  
  def search
    session[:criterions] ||= []
    session[:sortings] ||= []
    puts "======================="
    puts "criterions: #{session[:criterions].inspect}"
    puts "sortings: #{session[:sortings].inspect}"
    puts "------------------------"
    @all_filters_criterions = []
    @selected_filters = []
    session[:criterions].each do |criterions|
      c = Criterion.find(criterions.first)
      f = c.filter
      @all_filters_criterions << [f, criterions]
      @selected_filters << f
    end
  end
        
  def select_filter
    # if index = session[:selected_filters].index{|i| i[0] == params[:filter_id].to_i}
    #       session[:selected_filters].delete_at(index)
    #     else
    #       session[:selected_filters] << [params[:filter_id].to_i, params["order_by"] ? params["order_by"].to_s : "desc"] #change
    #     end
    #     session[:filter_sorting] = [params[:filter_id].to_i, params["order_by"] ? params["order_by"].to_s : "desc"]
    #     redirect_to action: 'search'
    filter = Filter.find(params[:filter_id])
    respond_to do |format|
      format.html{redirect_to action: 'search'}
      format.json{render json: [filter, filter.criterions]}
    end
  end
  
  def filter_sort
    session[:selected_filters][params[:index].to_i][1] = params[:order_by].to_s #if only one filter, than delete string and change upper
    session[:filter_sorting][1] = params[:order_by].to_s
    redirect_to action: 'search'
  end
  
  def date_sort
    if Article::DATE_TYPES.include?(params[:date_type].to_s)
      order_by = "desc"
      order_by = "asc" if params["order_by"].to_s == "asc"
      session[:date_sorting] = [params[:date_type].to_s, order_by]
    end
    redirect_to action: 'search'
  end
  
  def criterion_choose
    session[:criterion_ids] ||= []
    criterion_id = params[:criterion_id].to_i
    unless session[:criterion_ids].include?(criterion_id)
      session[:criterion_ids] << criterion_id
    else
      session[:criterion_ids].delete(criterion_id)
    end
    redirect_to action: 'search'
  end
  
  def reset_date_sort
    session[:date_sorting] = nil #created_at, updated_at, last_comment_at, original_at
    redirect_to action: 'search'
  end
  def reset_filter_selection
    session[:selected_filters] = []
    session[:criterion_ids] = []
    session[:filter_sorting] = nil
    redirect_to action: 'search'
  end
  
  def delete_filter_selection
    #delete criterion_ids
    filter_order_by = session[:selected_filters].delete_at(params[:index].to_i)
    f = Filter.find(filter_order_by[0])
    if session[:filter_sorting] and session[:filter_sorting][0] == f.id
      session[:filter_sorting] = nil
    end
    f.criterions.each do |criterion|
      session[:criterion_ids].delete(criterion.id)
    end
    redirect_to action: 'search'
  end
  
  def show
    @comment = Comment.new
  end
  
  def criterion_delete
    article = Article.find(params[:id])
    criterion = Criterion.find(params[:criterion_id])
    article.criterions.delete(criterion)
    redirect_to article
  end
  
  def add_criterion
  end

  def new
    gon.criterion_count = 1
    gon.filters = @filters
    @article = Article.new
  end

  def edit
  end

  def create
    @article = Article.new(params[:article])
    @article.user = User.first
    if params[:criterions]
      params[:criterions].each do |num, criterion_attributes|
        #ADD FOR DATA
        t = Criterion.find_or_create_by_name(criterion_attributes[:name])
        t.filter = Filter.find(criterion_attributes[:filter_id]) unless t.filter
        t.save
        @article.criterions << t
      end
    end

    if @article.save
      redirect_to article_path(@article.id)
    else
      render action: 'new', :notice => "Can't create article"
    end
  end

  def update
    if @article.update_attributes(params[:article])
      redirect_to @article, notice: 'Article was successfully updated.'
    else
      render action: "edit", :notice => "Can't update article"
    end
  end

  def destroy
    @article.destroy
    redirect_to articles_url
  end
  
  def find_filters
    @filters = Filter.all
  end
  
end
