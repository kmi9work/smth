class CriterionsController < ApplicationController
  skip_authorization_check
  def autocomplete
    @criterions = Criterion.where(:filter_id => params[:filter_id]).where("name like ?", "%#{params[:term]}%")
    render json: @criterions.map(&:name)
  end
end
