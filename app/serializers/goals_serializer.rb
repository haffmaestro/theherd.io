class GoalsSerializer < ActiveModel::Serializer
  attributes :id, :focus_area_id, :focus_area ,:body, :done, :due_date

  def focus_area
  	object.focus_area.name
  end
end
