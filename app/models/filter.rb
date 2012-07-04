class Filter < ActiveRecord::Base
  attr_accessible :name
  has_many :criterions
end
