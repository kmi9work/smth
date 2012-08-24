class DmpRequest < ActiveRecord::Base
  attr_accessible :name, :content, :q, :country, :city, :university, :school, :school_year, :uni_year, :age_from, :age_to, :online, :photo, :status, :sex, :offset, :start_offset, :group, :query
  validates :name, :presence => true
  validates :content, :presence => true
  has_many :dmp_admin_dmp_request_vkusers
  has_many :vkusers, through: :dmp_admin_dmp_request_vkusers
  before_save :check_query
  
  def check_query
    if query.present?
      if query =~ /(\&?offset=\d+)/
        self.query.sub!($1, '')
      end
      if query =~ /((http:\/\/)?vk.com.+\?)/
        self.query.sub!($1, '')
      end
    end
  end
  
  def vk_attrs
    return attributes.delete_if{|k,v| [:name, :id, :content, :created_at, :updated_at, :offset].include?(k.to_sym)}
  end
  
  def nilify!
    self.country = self.city = self.university = self.school = nil
  end
  # def ids_to_names!
  #   unless country.blank?
  #     country_id = Vkuser.get_country params[:country].gsub(/<.*?>/,'').strip
  #     request_params[:country] = country_id
  #   end
  #   unless city.blank?
  #     country_id = 1 unless country_id
  #     city_id = Vkuser.get_city_id country_id, params[:city].gsub(/<.*?>/,'').strip
  #     request_params[:city] = city_id
  #   end
  #   unless university.blank?
  #     country_id = 1 unless country_id
  #     city_id = 1 unless city_id
  #     university_id = Vkuser.get_university_id country_id, city_id, params[:university].gsub(/<.*?>/,'').strip
  #     request_params[:university] = university_id
  #   end
  #   unless school.blank?
  #     city_id = 1 unless city_id
  #     school_id = Vkuser.get_school_id city_id, params[:school].gsub(/<.*?>/,'').strip
  #     request_params[:school] = school_id
  #   end
  # end
  
end
