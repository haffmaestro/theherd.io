module Api
  class UserWeekliesController < BaseController
    
    def update
      user = User.find params[:id]
      service = Reports::UpdateUserWeekly.new(user)
      if service.call
        render json: {updated: true}
      else
        render json: {updated: false}
      end
    end

  end
end