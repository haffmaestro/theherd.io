class Api::GoalsController < Api::BaseController

	def index
		@herd = current_herd
		render json: @herd.users, each_serializer: UserGoalsSerializer
	end
end
