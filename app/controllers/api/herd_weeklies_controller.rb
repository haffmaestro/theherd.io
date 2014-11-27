class Api::HerdWeekliesController < Api::BaseController
  before_action :find_herd_weekly, only: [:show]
  before_action :authenticate_user!

  YEARWEEKREGEX = /^(201[45]-[0-5]\d)/
  
  def index
  end

  def show
    render json: HerdWeeklySerializer.new(@herd_weekly)
  end

  private

  def year_week_id_format?
    params[:id] =~ YEARWEEKREGEX 
  end

  def find_herd_weekly
    if year_week_id_format?
      @herd_weekly = HerdWeekly.find_for_week(current_herd, params[:id])
    elsif params[:id] == 'current'
      @herd_weekly = current_herd.herd_weeklies.last
    else
      @herd_weekly = HerdWeekly.find params[:id]
    end
  end


end