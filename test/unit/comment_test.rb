require 'test_helper'

class CommentTest < ActiveSupport::TestCase
  test "add comment with empty content" do
    c = Comment.new(:content => "")
    c.user = User.first
    c.article = Article.first
    assert !c.save
  end
  
  test "add comment with parent article" do
    c = Comment.new(:content => "foobar")
    c.user = User.first
    c.article = Article.first
    assert c.save
  end
  
  test "add comment with parent comment" do
    c = Comment.new(:content => "foobar")
    c.user = User.first
    c.parent = Comment.first
    assert c.save
  end
  
  test "add comment without parent" do
    c = Comment.new(:content => "foobar")
    c.user = User.first
    assert !c.save
  end
  
  test "add comment without user" do
    c = Comment.new(:content => "foobar")
    c.article = Article.first
    assert !c.save
  end
  
  # test "the truth" do
  #   assert true
  # end
end
