class Tgroup < ActiveRecord::Base
  attr_accessible :name
  has_many :tags
end
