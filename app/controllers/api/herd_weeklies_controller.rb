module Api
  class HerdWeekliesController < Api::BaseController
    before_action :find_herd_weekly, only: [:show]
    before_action :authenticate_user!

    YEARWEEKREGEX = /^(201[45]-[0-5]\d)/
    
    def index
      @weeklies = @herd.herd_weeklies
      render json: @weeklies, each_serializer: SimpleHerdWeeklySerializer
    end

    def show
      render json: @herd_weekly, each_serializer: HerdWeeklySerializer
    end

    private
    
    def year_week_id_format?
      params[:id] =~ YEARWEEKREGEX 
    end

    def find_herd_weekly
      if year_week_id_format?
        @herd_weekly = HerdWeekly.find_for_week(current_herd, params[:id])
      elsif params[:id] == 'current'
        @herd_weekly = current_herd.herd_weeklies.order("year DESC, week DESC").first
      else
        @herd_weekly = HerdWeekly.find params[:id]
      end
    end
    
  end
end