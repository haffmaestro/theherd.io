class HerdWeeklySerializer < ActiveModel::Serializer
  attributes :herd_id, :week, :year, :year_week_id

  has_many :user_weeklies

  def year_week_id
    "#{object.year}-#{object.week}"
  end
end