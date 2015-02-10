class GoalSerializer < ActiveModel::Serializer
  attributes :id ,:body, :done, :due_date, :user_id, :focus_area_id

  def user_id
    object.focus_area.user_id
  end

end
