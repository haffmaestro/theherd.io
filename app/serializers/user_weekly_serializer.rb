class UserWeeklySerializer < ActiveModel::Serializer
  attributes :herd_weekly_id, :user_id, :first_name
  has_many :sections

  def first_name
    object.user.first_name
  end

end