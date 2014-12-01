class GoalsSerializer < ActiveModel::Serializer
  attributes :id ,:body, :done, :due_date

end
