class SimpleHerdWeeklySerializer < ActiveModel::Serializer
  attributes :id, :herd_id, :year, :week
end