class User < ActiveRecord::Base
  
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  attr_accessible :data, :name
  has_many :articles
  has_many :comments
  
  # before_save :not_admin !!!!!!!!!!!!!!!!
  
  def can_manage_article?(article)
    admin? || article.user == self
  end
  
  protected
  def not_admin
    self.admin = false
    true
  end
end
