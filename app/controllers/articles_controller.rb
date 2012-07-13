class ArticlesController < ApplicationController
  # GET /articles
  # GET /articles.json
  def index
    @filters = Filter.all
    # @articles = Article.all
    puts "======================="
    puts "criterion_ids: #{session[:criterion_ids].inspect}"
    puts "filter_sorting: #{session[:filter_sorting].inspect}"
    puts "date_sorting: #{session[:date_sorting].inspect}"
    puts "------------------------"
    @articles = Article.filter_by(session[:criterion_ids], session[:filter_sorting], session[:date_sorting])   
    session[:selected_filters] ||= [] 
    @selected_filters = session[:selected_filters].map{|st| [Filter.find(st[0]), st[1]]}
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @articles }
    end
  end
  
  def select_filter
    session[:selected_filters] << [params[:filter_id], params["order_by"] ? params["order_by"].to_s : "desc"] #change
    session[:filter_sorting] = [params[:filter_id].to_i, params["order_by"] ? params["order_by"].to_s : "desc"]
    redirect_to '/articles'
  end
  
  def filter_sort
    session[:selected_filters][params[:index].to_i][1] = params[:order_by].to_s #if only one filter, than delete string and change upper
    session[:filter_sorting][1] = params[:order_by].to_s
    redirect_to '/articles'
  end
  
  def date_sort
    if Article::DATE_TYPES.include?(params[:date_type].to_s)
      order_by = "desc"
      order_by = "asc" if params["order_by"].to_s == "asc"
      session[:date_sorting] = [params[:date_type].to_s, order_by]
    end
    redirect_to '/articles'
  end
  
  def criterion_choose
    session[:criterion_ids] ||= []
    criterion_id = params[:criterion_id].to_i
    unless session[:criterion_ids].include?(criterion_id)
      session[:criterion_ids] << criterion_id
    else
      session[:criterion_ids].delete(criterion_id)
    end
    redirect_to '/articles'
  end
  
  def reset_date_sort
    session[:date_sorting] = nil #created_at, updated_at, last_comment_at, original_at
    redirect_to '/articles'
  end
  def reset_filter_selection
    session[:selected_filters] = []
    session[:criterion_ids] = []
    session[:filter_sorting] = nil
    redirect_to '/articles'
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
    redirect_to '/articles'
  end
  
  
  # GET /articles/1
  # GET /articles/1.json
  def show
    @comment = Comment.new
    @article = Article.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @article }
    end
  end
  
  def criterion_delete
    article = Article.find(params[:id])
    criterion = Criterion.find(params[:criterion_id])
    article.criterions.delete(criterion)
    redirect_to article
  end
  
  def autocomplete_criterion
    puts params[:filter_id], "================"
    @criterions = Criterion.where(:filter_id => params[:filter_id]).where("name like ?", "%#{params[:term]}%")
    render json: @criterions.map(&:name)
  end
  
  def add_criterion
  end

  # GET /articles/new
  # GET /articles/new.json
  def new
    gon.autocomplete_criterion_path = autocomplete_criterion_path(2)
    gon.criterion_count = 1
    gon.filters = Filter.all
    @article = Article.new
    #@filters = Filter.all#.collect{|tg| [tg.name, tg.id]}
  end

  # GET /articles/1/edit
  def edit
    @article = Article.find(params[:id])
  end

  # POST /articles
  # POST /articles.json
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
      puts "---------------"
      p @article.errors
      puts "==============="
      render 'new', :notice => "Can't create article"
    end
  end

  # PUT /articles/1
  # PUT /articles/1.json
  def update
    @article = Article.find(params[:id])

    respond_to do |format|
      if @article.update_attributes(params[:article])
        format.html { redirect_to @article, notice: 'Article was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /articles/1
  # DELETE /articles/1.json
  def destroy
    @article = Article.find(params[:id])
    @article.destroy

    respond_to do |format|
      format.html { redirect_to articles_url }
      format.json { head :no_content }
    end
  end
end
