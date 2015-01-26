class Api::FocusAreasController < Api::BaseController
	def index
		render json: current_user.focus_areas, each_serializer: FocusAreaSimpleSerializer
	end

  def edit
  end

	def create 
	end

	def destroy
	end
end