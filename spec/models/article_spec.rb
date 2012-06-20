require 'spec_helper'

def make_first num
  articles = []
  num.times do
    articles << create(:article)
  end
      
  tags1 = []
  num.times do |i|
    t = create(:tag)
    tags1 << t
    articles[i].tags << t
  end
  tags2 = []
  num.times do |i|
    tags2 << create(:tag, tgroup: tags1[0].tgroup)
  end
  (num/3).times do |i|
    articles[i+1].tags << tags2[0]
  end
  my_tgroup = tags2[0].tgroup
  return my_tgroup
end

describe Article do
  it "finds all articles with tgroup" do
    n = 10
    my_tgroup = make_first n
    my_articles = Article.tgroup_articles(my_tgroup)
    
    # puts "#{my_articles.size} == #{num/3 + 1}"
    (my_articles.size == n/3 + 1).should be_true
  end
  
  it "sorts article in tgroup" do
    n = 10
    my_tgroup = make_first n
    my_articles = Article.tgroup_articles_sorted(my_tgroup, :desc)
  end
end