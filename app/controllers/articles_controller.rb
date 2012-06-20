class ArticlesController < ApplicationController
  # GET /articles
  # GET /articles.json
  def index
    @tgroups = Tgroup.all
    if session[:selected_tgroups] and !session[:selected_tgroups].empty?
      @articles = Article.tgroup_articles(session[:selected_tgroups], params["order_by"] ? params["order_by"] : "desc")
    else
      session[:selected_tgroups] = []
      @articles = Article.all
    end
    
    @selected_tgroups = Tgroup.find(session[:selected_tgroups])
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @articles }
    end
  end
  
  def select_tgroup
    session[:selected_tgroups] << params[:tgroup_id]
    @selected_tgroups = Tgroup.find(session[:selected_tgroups])
    redirect_to '/articles'
  end
  
  def reset_tgroup_selection
    @selected_tgroups = (session[:selected_tgroups] = [])
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
  
  def tag_delete
    article = Article.find(params[:id])
    tag = Tag.find(params[:tag_id])
    article.tags.delete(tag)
    redirect_to article
  end

  # GET /articles/new
  # GET /articles/new.json
  def new
    @article = Article.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @article }
    end
  end

  # GET /articles/1/edit
  def edit
    @article = Article.find(params[:id])
  end

  # POST /articles
  # POST /articles.json
  def create
    puts "----------------------"
    puts params[:article].to_s
    @article = Article.new(params[:article])

    respond_to do |format|
      if @article.save
        format.html { redirect_to @article, notice: 'Article was successfully created.' }
        format.json { render json: @article, status: :created, location: @article }
      else
        format.html { render action: "new" }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
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
