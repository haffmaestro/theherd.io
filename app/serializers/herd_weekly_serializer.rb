class HerdWeeklySerializer < ActiveModel::Serializer
  attributes :herd_id, :week, :year
  

  has_many :user_weeklies
end