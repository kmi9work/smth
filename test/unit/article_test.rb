require 'test_helper'

class ArticleTest < ActiveSupport::TestCase
  test "add article with empty name" do
    a = Article.new(:name => "", :content => "foo")
    a.user = User.first
    assert !a.save
  end
  test "add article with empty content" do
    a = Article.new(:name => "bar", :content => "")
    a.user = User.first
    assert !a.save
  end
  test "add article without user" do
    a = Article.new(:name => "foo", :content => "bar")
    assert !a.save
  end
  # test "the truth" do
  #   assert true
  # end
end
