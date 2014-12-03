class GoalSerializer < ActiveModel::Serializer
  attributes :id ,:body, :done, :due_date

end
