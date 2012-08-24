class DmpAdminDmpRequestVkuser < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :dmp_admin
  belongs_to :dmp_request
  belongs_to :vkuser
end
