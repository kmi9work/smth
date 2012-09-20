class ApplicationController < ActionController::Base
  protect_from_forgery
  # check_authorization :unless => :devise_controller?
=begin
  rescue_from CanCan::AccessDenied do |exception|
    puts "++++++++++++++++++++++++++++++++"
    puts exception.message
    puts "Can:"
    puts can?(:read, Criterion)
    puts can?(:read, Filter)
    redirect_to '/articles/search', :alert => exception.message
  end
=end
end
