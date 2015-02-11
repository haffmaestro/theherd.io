class WeeklyTaskSerializer < ActiveModel::Serializer
  attributes :id, :section_id, :body, :done, :user_id

  def user_id
    object.section.user_weekly.user_id
  end

end