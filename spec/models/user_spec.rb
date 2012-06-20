require 'spec_helper'

describe User do
  # it "authenticates with matching username and password" do
    # user = create(:user, name: "batman", password: "secret")
  ######################################################################
  #   ApplicationController.allow_forgery_protection = false
  #   app.post('/sign_in', {"user"=>{"name"=>"login", "password"=>"password"}})
  #   app.get '/some_other_path_that_only_works_if_logged_in'
  #   pp app.response.body
  ######################################################################
  # end
  # 
  # it "does not authenticate with incorrect password" do
  #     create(:user, name: "batman", password: "secret")
  #     User.authenticate("batman", "incorrect").should be_nil
  #   end
  
  it "can manage articles he owns" do
    article = build(:article)
    user = article.user
    user.can_manage_article?(article).should be_true
    user.can_manage_article?(Article.new).should be_false
  end

  it "can manage any articles as admin" do
    build(:admin).can_manage_article?(Article.new).should be_true
    build(:user).can_manage_article?(Article.new).should be_false
  end
end