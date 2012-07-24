class DmpRequest < ActiveRecord::Base
  attr_accessible :name, :content, :q, :country, :city, :university, :school
  validates :name, :presence => true
  validates :content, :presence => true
  
  def vk_attrs
    return {:q => @q, :country => @country, :city => @city, :university => @university, :school => @school}
  end
  
end
