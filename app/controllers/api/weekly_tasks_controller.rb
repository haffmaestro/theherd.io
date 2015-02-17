module Api
	class WeeklyTasksController < Api::BaseController

		def update
			# render json: params
			task = WeeklyTask.find params[:id]
			if task.update task_params
				render json: task, serializer: WeeklyTaskSerializer
				##Synchronize with TODOIST
				if current_user.todoist_api_token
					if task.done && task.todoist_id
						Todoist.complete_items(current_user, task)
					elsif task.todoist_id
						Todoist.uncomplete_items(current_user, task)
					end
				end
			else
				render json: {updated: false}
			end
		end

		def create
			section = Section.find params[:weekly_task][:section_id]
			task = section.weekly_tasks.new task_params
			if task.save
				render json: task, serializer: WeeklyTaskSerializer
				##Synchronize with TODOIST
				if current_user.todoist_api_token
					response = Todoist.new_item(current_user, task, "+7")
					if response
						task.todoist_id = response["id"]
						task.save
					end
				end
			else
				render json: {saved: false, task: task}
			end
		end

		def destroy
			task = WeeklyTask.find params[:id]
			if task.destroy
				render json: task, serializer: WeeklyTaskSerializer
				##Synchronize with TODOIST
				if current_user.todoist_api_token && task.todoist_id
					Todoist.delete_items(current_user, task)
				end
			else
				render json: {destroyed: false}
			end
		end


		private

		def task_params
			params.require(:weekly_task).permit(:done, :body, :section_id)
		end

	end
end