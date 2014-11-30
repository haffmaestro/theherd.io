class WeeklyTaskSerializer < ActiveModel::Serializer
  attributes :id, :section_id, :body, :done

end