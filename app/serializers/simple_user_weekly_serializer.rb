class SimpleUserWeeklySerializer < ActiveModel::Serializer
  attributes :herd_weekly_id, :user_id, :first_name, :year_week_id
  
  def first_name
    object.user.first_name
  end

end
