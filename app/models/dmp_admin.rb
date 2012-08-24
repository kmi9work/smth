class DmpAdmin < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  # attr_accessible :title, :body
  has_many :dmp_admin_dmp_request_vkusers
  # has_many :vkusers, through: :dmp_admin_dmp_request_vkusers
  def vkusers request
    DmpAdminDmpRequestVkuser.where(dmp_admin_id: id, dmp_request_id: request).map(&:vkuser)
  end
end
