#coding: utf-8
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

@words = 'Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.'.split()
@tgroup_hash = {'газета' => ['Коммерсант', 'Ведомости', 'Завтра', 'Комсомольская правда'], 
                'статья' => ['Нельзя допустить, чтобы воины превратились в торговцев', 
                             'Медведев и развитие',
                             'Кризис и другие',
                             'Россия обречена снова стать сверхдержавой '], 
                'дата' => ['9 октября 2007', '12.04.2012', '11.02.2009', '18 фев 2012', '4 май 2011'], 
                'организация' => ['Суть времени', 'Единая Россия', 'Народный собор', 'РПЦ'],
                'автор' => ['С.Е. Кургинян', 'В. Черкесов', 'Н. Стариков', 'Хомяков', 'И. Медведева', 'В. Путин']}

@users = []
10.times do |i|
  @users << User.create(:name => "User#{i}", :data => "#{i**3}", :email => "kmi#{i}@gmail.com", :password => "#{i.to_s * 8}", :password_confirmation => "#{i.to_s * 8}")
end

puts "Users: #{@users.size}"

#ARTICLES

f = File.new("lib/data/data.txt", "r")
@contents = []
while f.gets
  if $_.strip == "-----"
    s = "" 
    next
  end
  if $_.strip == "====="
    @contents << s 
    next
  end
  s += $_
end
narticles = @contents.size
f.close

@articles = []
narticles.times do |i|
  a = Article.new(:name => "#{@words[rand(@words.size)].capitalize} #{Array.new(rand(5)){@words[rand(@words.size)]}.join(" ")}", :content => @contents[i])
  a.user = @users[rand(@users.size)]
  a.save
  @articles << a
end

puts "Articles: #{narticles}"

#TAGS

@tgroups = []
ntg, nt = 0, 0
@tags = []
@tgroup_hash.each do |key, names|
  tg = Tgroup.create(:name => key)
  names.each do |name|
    t = Tag.new(:name => name)
    t.tgroup = tg
    t.save 
    nt += 1
    @tags << t
  end
  @tgroups << tg
  ntg += 1
end

(nt*2).times do
  @articles[rand(narticles)].tags << @tags[rand(nt)]
end

puts "Tgroups: #{ntg}\nTags: #{nt}"

#COMMENTS

f = File.new("lib/data/comments_data.txt", "r")
@contents = []
while f.gets
  @contents << $_ unless $_.strip.empty?
end
f.close


ncomments = rand(*4)

@top_comments = []
(narticles*2).times do |i|
  c = Comment.new(:content => @contents[rand(@contents.size)])
  c.article = @articles[rand(narticles)]
  c.user = @users[rand(@users.size)]
  c.save
  @top_comments << c
end

@comments = @top_comments.dup

def addcomment parent, n
  return if n == 0
  c = Comment.new(:content => @contents[rand(@contents.size)])
  c.parent = parent
  c.user = @users[rand(@users.size)]
  c.save
  @comments << c
  addcomment c, n-1
end

(narticles + rand(narticles*2)).times do |i|
  r = rand(@users.size)
  addcomment @top_comments[rand(@top_comments.size)], r
end

puts "Top comments: #{@top_comments.size}"
puts "Comments: #{@comments.size}"

