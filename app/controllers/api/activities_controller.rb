module Api
  class ActivitiesController < ApplicationController
    
    def index
      @activities = PublicActivity::Activity.where(herd_id: current_herd.id).order("created_at desc").limit(20)
      render json: @activities, each_serializer: ActivitiesSerializer
    end
    
  end
end