class ExtendedGoalSerializer < ActiveModel::Serializer
  attributes :id ,:body, :done, :due_date, :focus_area

  def focus_area
    if object.focus_area
      object.focus_area.name
    else
      nil
    end
  end
end
