class Api::WeeklyTasksController < Api::BaseController

	def update
		# render json: params
		task = WeeklyTask.find params[:id]
		if task.update task_params
			render json: {updated: true}
		else
			render json: {updated: false}
		end
	end

	def create
		render json: params
	end


	private

	def task_params
		params.require(:weekly_task).permit(:done, :body, :section_id)
	end

end