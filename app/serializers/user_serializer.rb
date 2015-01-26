class UserSerializer < ActiveModel::Serializer
  attributes :id, :first_name, :last_name, :email, :comment_count, :goals_count, :weekly_tasks_count, :weekly_reports_count

  def comment_count
    object.comments.count
  end

  def goals_count
    count = 0
    object.goals.each do |goal|
      count+= 1 if goal.done
    end
    return count
  end

  def weekly_tasks_count
    count = 0
    object.weekly_tasks.each do |task|
      count+= 1 if task.done
    end
    return count
  end

  def weekly_reports_count
    object.user_weeklies.count
  end

end