class Comment < ActiveRecord::Base
=begin
  validates_presence_of :content, :user
  validates :parent, :presence => true, :if => 'article.nil?'
  validates :article, :presence => true, :if => 'parent.nil?'
  
  attr_accessible :content, :user_id
  belongs_to :article
  belongs_to :user
  
  
  acts_as_tree :order => 'created_at'
=end
end
