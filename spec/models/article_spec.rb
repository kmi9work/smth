require 'spec_helper'

def make_first num
  articles = []
  num.times do
    articles << create(:article)
  end
      
  criterions1 = []
  num.times do |i|
    t = create(:criterion)
    criterions1 << t
    articles[i].criterions << t
  end
  criterions2 = []
  num.times do |i|
    criterions2 << create(:criterion, filter: criterions1[0].filter)
  end
  (num/3).times do |i|
    articles[i+1].criterions << criterions2[0]
  end
  my_filter = criterions2[0].filter
  return my_filter
end

describe Article do
  it "finds all articles with filter" do
    n = 10
    my_filter = make_first n
    my_articles = Article.filter_articles(my_filter)
    
    # puts "#{my_articles.size} == #{num/3 + 1}"
    (my_articles.size == n/3 + 1).should be_true
  end
  
  it "sorts article in filter" do
    n = 10
    my_filter = make_first n
    my_articles = Article.filter_articles_sorted(my_filter, :desc)
  end
end