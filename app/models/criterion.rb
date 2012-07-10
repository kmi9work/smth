class Criterion < ActiveRecord::Base
  attr_accessible :name
  has_and_belongs_to_many :articles
  belongs_to :filter
end