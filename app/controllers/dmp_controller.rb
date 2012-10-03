#encoding: utf-8
class DmpController < ApplicationController
  layout false
  helper_method :is_user?
  helper_method :is_admin?
  before_filter :can_user?
  before_filter :can_admin?, :only => [:new, :create, :edit, :update, :destroy]
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
  
  # def country_ok_ajax
  #    if params[:country]
  #      @country = params[:country]
  #      country_id = Vkuser.get_country_id params[:country]
  #      if country_id 
  #        session[:dmp_country] = country_id
  #        render 'country_ok'
  #      else
  #        render 'error_country_ok'
  #      end
  #    else
  #      render 'error_country_ok'
  #    end
  #  end
  #  
  #  def city_ok_ajax
  #    
  #  end
  #  
  #  def school_ok_ajax
  #    
  #  end
  #  
  #  def university_ok_ajax
  #    
  #  end
  #  
  def show
    @dmp_request = DmpRequest.find(params[:id])
    @vkusers = current_dmp_admin.vkusers(@dmp_request).compact
    @content = ""
  end
  
  def show_vkusers
    @dmp_request = DmpRequest.find(params[:id])
    @vkusers = current_dmp_admin.vkusers(@dmp_request).compact
    index = 0
    vksize_buf = -1
    offset = @dmp_request.offset
    @error = nil
    @content = Vkuser.get_vkusers(@dmp_request, offset, current_dmp_admin)
    while @vkusers.size < 20 and (index += 1) <= 100
      ans, status = Vkuser.get_vkusers(@dmp_request, offset, current_dmp_admin) 
      if status == 1
        @error = "Vk DOM changed"
        break 
      elsif status == 2
        break
      end
      @vkusers += ans
      if status == 0
        @dmp_request.offset += 20
        @dmp_request.save
      end
      offset += 20
    end
    @vkusers.compact!
    render 'show'
  end
    
  def vkuser_sent
    vkuser = Vkuser.find(params[:vkid])
    vkuser.sent = true
    vkuser.save
    vkuser.dmp_admin_dmp_request_vkuser.destroy
    render :nothing => true
  end
  
  def new
    @countries = Vkuser.get_countries
    @dmp_request = DmpRequest.new
  end
  
  def create
    request_params = get_request_from_params params[:dmp_request]
    @dmp_request = DmpRequest.new(request_params)
    @dmp_request.start_offset = @dmp_request.offset
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
    @dmp_request.nilify!
  end  
  
  def update
    @dmp_request = DmpRequest.find(params[:id])
    request_params = get_request_from_params params[:dmp_request]
    puts "update:"
    p request_params
    @dmp_request.start_offset = request_params[:offset]
    request_params.delete(:offset)
    if @dmp_request.update_attributes(request_params)
      redirect_to '/dmp', :notice => "updated"
    else
      redirect_to "/dmp/edit/#{params[:id]}", :notice => "error: #{@dmp_request.errors.full_messages}"
    end
  end
  
  def destroy
    dmp_request = DmpRequest.find(params[:id])
    dmp_request.destroy
    redirect_to '/dmp'
  end
  protected
  def get_request_from_params params
    country_id, city_id, university_id, school_id = nil, nil, nil, nil
    unless params[:country].blank?
      country_id = Vkuser.get_country_id params[:country].gsub(/<.*?>/,'').strip
      params[:country] = country_id
    end
    unless params[:city].blank?
      country_id = 1 unless country_id
      city_id = Vkuser.get_city_id country_id, params[:city].gsub(/<.*?>/,'').strip
      params[:city] = city_id
    end
    unless params[:university].blank?
      country_id = 1 unless country_id
      city_id = 1 unless city_id
      university_id = Vkuser.get_university_id country_id, city_id, params[:university].gsub(/<.*?>/,'').strip
      params[:university] = university_id
    end
    unless params[:school].blank?
      city_id = 1 unless city_id
      school_id = Vkuser.get_school_id city_id, params[:school].gsub(/<.*?>/,'').strip
      params[:school] = school_id
    end
    return params
  end
  def is_user?
    current_dmp_admin and current_dmp_admin.role >= 1
  end
  def is_admin?
    current_dmp_admin and current_dmp_admin.role >= 2
  end
  def can_user?
    unless is_user?
      redirect_to new_dmp_admin_session_path, notice: "U are not allowed to do this"
    end
  end
  def can_admin?
    unless is_admin?
      redirect_to new_dmp_admin_session_path, notice: "U are not allowed to do this"
    end
  end
end
