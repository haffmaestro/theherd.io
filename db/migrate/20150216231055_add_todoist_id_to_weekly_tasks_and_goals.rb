class AddTodoistIdToWeeklyTasksAndGoals < ActiveRecord::Migration
  def change
    add_column :weekly_tasks, :todoist_id, :integer
    add_column :goals, :todoist_id, :integer
  end
end
