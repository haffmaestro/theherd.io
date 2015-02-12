class SimpleHerdWeeklySerializer < ActiveModel::Serializer
  attributes :id, :herd_id, :year, :week, :year_week_id
end