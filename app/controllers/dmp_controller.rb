#encoding: utf-8
class DmpController < ApplicationController
  layout false
  before_filter :authenticate_dmp_admin!, :only => [:new, :create, :edit, :update, :destroy]
  def index
    @dmp_requests = DmpRequest.all
        # while @vkusers.size < 20
    #       @vkusers = Vkuser.get_vkusers({:city => 10, :country => 1, :name => 1, :section => "people"}, offset) #:q => "Ivan",
    #       offset += 20
    #     end
  end
  
  def country_autocomplete
    response = Vkuser.get_countries 
    render response
  end
  
  def city_autocomplete
    country_id = "1"
    country_id = Vkuser.get_country_id params[:country] if params[:country]
    response = Vkuser.get_cities country_id, params[:term]
    render :json => response
  end
  
  def school_autocomplete
    city_id = "1"
    city_id = Vkuser.get_city_id params[:city] if params[:city]
    response = Vkuser.get_schools city_id, params[:term]
    render :json => response
  end
  
  def university_autocomplete
    country_id = "1"
    country_id = Vkuser.get_country_id params[:country] if params[:country]
    city_id = "1"
    city_id = Vkuser.get_city_id params[:city] if params[:city]
    response = Vkuser.get_universities country_id, city_id, params[:term]
    render :json => response
  end
  
  def country_ok_ajax
    if params[:country]
      @country = params[:country]
      country_id = Vkuser.get_country_id params[:country]
      if country_id 
        session[:dmp_country] = country_id
        render 'country_ok'
      else
        render 'error_country_ok'
      end
    else
      render 'error_country_ok'
    end
  end
  
  def city_ok_ajax
    
  end
  
  def school_ok_ajax
    
  end
  
  def university_ok_ajax
    
  end
  
  def show
    @dmp_request = DmpRequest.find(params[:id])
  end
  
  def show_vkusers
    @dmp_request = DmpRequest.find(params[:id])
    @vkusers = []
    index = 0
    vksize_buf = -1
    offset = 0
  
    while @vkusers.size < 20 and (index += 1) < 100
      vksize_buf = @vkusers.size
      @vkusers += Vkuser.get_vkusers(@dmp_request, offset) 
      offset += 20
    end
  end
  
  def vkuser_sent
    vkuser = Vkuser.new(:vkid => params[:vkid])
    if vkuser.valid?
      vkuser.save
      render :nothing => true
    else
      render :nothing => true
    end
  end
  
  def new
    @countries = Vkuser.get_countries
    @dmp_request = DmpRequest.new
  end
  
  def create
    request_params = get_request_from_params params[:dmp_request]
    puts "create:"
    p request_params
    @dmp_request = DmpRequest.new(request_params)
    if @dmp_request.valid?
      @dmp_request.save
      redirect_to '/dmp', :notice => "created"
    else
      redirect_to '/dmp/new', :notice => "error: #{@dmp_request.errors.full_messages}"
    end
  end
  
  def edit
    @countries = Vkuser.get_countries
    @dmp_request = DmpRequest.find(params[:id])
  end  
  
  def update
    @dmp_request = DmpRequest.find(params[:id])
    request_params = get_request_from_params params[:dmp_request]
    if @dmp_request.update_attributes(request_params)
      redirect_to '/dmp', :notice => "updated"
    else
      redirect_to '/dmp/new', :notice => "error: #{@dmp_request.errors.full_messages}"
    end
  end
  
  def destroy
    dmp_request = DmpRequest.find(params[:id])
    dmp_request.destroy
    redirect_to '/dmp'
  end
  protected
  def get_request_from_params params
    puts '================'
    p params
    query, country_id, city_id, university_id, school_id = nil, nil, nil, nil, nil
    request_params = {}
    if params[:q] and !params[:q].empty?
      query = params[:q]
      request_params[:q] = query
    end
    if params[:country] and !params[:country].empty?
      country_id = Vkuser.get_country_id params[:country].gsub(/<.*?>/,'').strip
      request_params[:country] = country_id
    end
    if params[:city] and !params[:city].empty?
      country_id = 1 unless country_id
      city_id = Vkuser.get_city_id country_id, params[:city].gsub(/<.*?>/,'').strip
      request_params[:city] = city_id
    end
    if params[:university] and !params[:university].empty?
      country_id = 1 unless country_id
      city_id = 1 unless city_id
      university_id = Vkuser.get_university_id country_id, city_id, params[:university].gsub(/<.*?>/,'').strip
      request_params[:university] = university_id
    end
    if params[:school] and !params[:school].empty?
      city_id = 1 unless city_id
      school_id = Vkuser.get_school_id city_id, params[:school].gsub(/<.*?>/,'').strip
      request_params[:school] = school_id
    end
    request_params[:name] = params[:name]
    request_params[:content] = params[:content]
    return request_params
  end
end
