class Api::GoalsController < Api::BaseController

	def index
		@herd = current_herd
		render json: @herd.users.order(first_name: :desc), each_serializer: UserGoalsSerializer
	end

	def update
		# render json: params
		goal = Goal.find params[:id]
		if goal.update goal_params
			goal.reload
			render json: goal.done
		else
			render json: {updated: false}
		end
	end

	def create
		focus_area = FocusArea.find params[:goal][:focus_area_id]
		goal = focus_area.goals.new goal_params
		goal.due_date = params[:goal][:months].months.from_now - 1.day
		if goal.save
			goal.create_activity :create, owner: current_user, herd_id: current_herd.id
			render json:  goal, serializer: GoalSerializer
		else
			render json: {saved: false, goal: goal}
		end
	end

	def destroy
		goal = Goal.find params[:id]
		if goal.destroy
			render json: goal, serializer: GoalSerializer
		else
			render json: {destroyed: false}
		end
	end


	private

	def goal_params
		params.require(:goal).permit(:done, :body, :focus_area_id, :due_date, :id)
	end
end
