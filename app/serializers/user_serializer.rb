class UserSerializer < ActiveModel::Serializer
  delegate :current_user, to: :scope
  attributes :id, :first_name, :last_name, :email, :has_todoist, :picture_url
  attributes :comment_count, :goals_count, :weekly_tasks_count, :weekly_reports_count, :focus_areas
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
    count = 0
    object.user_weeklies.each do |task|
      count+= 1 if task.done
    end
    return count
  end

  def focus_areas
    result = []
    object.focus_areas.each do |focus_area|
      focus = focus_area.attributes
      additional_attributes = {
        :is_owner => current_user.id == object.id}
      focus.merge!(additional_attributes)
      result << focus
    end
    result
  end

end