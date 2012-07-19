#encoding: utf-8
class DmpController < ApplicationController
  layout false
  def index
    @vkusers = []
    offset = 0
    @countries = Vkuser.get_countries
    # while @vkusers.size < 20
    #       @vkusers = Vkuser.get_vkusers({:city => 10, :country => 1, :name => 1, :section => "people"}, offset) #:q => "Ivan",
    #       offset += 20
    #     end
  end
  
  def submit
    query, country_id, city_id, university_id, school_id = nil, nil, nil, nil, nil
    request_params = {}
    unless params[:query].empty?
      query = params[:query] 
      request_params[:q] = query
    end
    unless params[:country].empty?
      country_id = Vkuser.get_country_id params[:country]
      request_params[:country] = country_id
    end
    unless params[:city].empty?
      city_id = Vkuser.get_city_id country_id, params[:city]
      request_params[:city] = city_id
    end
    unless params[:university].empty?
      university_id = Vkuser.get_university_id country_id, city_id, params[:university]
      request_params[:university] = university_id
    end
    unless params[:school].empty?
      school_id = Vkuser.get_school_id city_id, params[:school] 
      request_params[:school] = school_id
    end
    
    request_params[:name] = 1
    request_params[:section] = "people"
    
    
    
    index = 0
    vksize_buf = -1
    offset = 0
    @vkusers = []
    while @vkusers.size < 20 and (index += 1) < 100
      vksize_buf = @vkusers.size
      @vkusers += Vkuser.get_vkusers(request_params, offset) 
      offset += 20
    end
    render 'index'
  end
  
  def country_autocomplete
    response = Vkuser.get_countries 
    render response
  end
  
  def city_autocomplete
    response = Vkuser.get_cities "1", params[:term]
    render :json => response
  end
  
  def school_autocomplete
    response = Vkuser.get_schools "1", params[:term]
    render :json => response
  end
  
  def university_autocomplete
    response = Vkuser.get_universities "1", "1", params[:term]
    render :json => response
  end
end
