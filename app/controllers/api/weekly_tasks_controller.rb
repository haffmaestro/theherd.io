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
		section = Section.find params[:weekly_task][:section_id]
		task = section.weekly_tasks.new task_params
		if task.save
			render json: {saved: true}
		else
			render json: {saved: false}
		end
	end

	def destroy
		task = WeeklyTask.find params[:id]
		if task.destroy
			render json: {destroyed: true}
		else
			render json: {destroyed: false}
		end
	end


	private

	def task_params
		params.require(:weekly_task).permit(:done, :body, :section_id)
	end

end