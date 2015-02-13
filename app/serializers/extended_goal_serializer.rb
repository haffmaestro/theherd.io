class ExtendedGoalSerializer < ActiveModel::Serializer
  attributes :id ,:body, :done, :due_date, :focus_area, :range

  def focus_area
    if object.focus_area
      object.focus_area.name
    else
      nil
    end
  end

  def range
    if (object.due_date.to_date > 3.years.from_now.to_date)
      return 3
    elsif ((1.year.from_now.to_date)..(3.year.from_now.to_date)).cover?(object.due_date.to_date)
      return 2
    elsif ((3.months.from_now.to_date)..(1.year.from_now.to_date)).cover?(object.due_date.to_date)
      return 1
    elsif ((1.month.from_now.to_date)..(3.months.from_now.to_date)).cover?(object.due_date.to_date)
      return 1
    else
      return 0
    end
  end
end
