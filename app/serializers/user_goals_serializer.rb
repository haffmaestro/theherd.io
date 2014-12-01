class UserGoalsSerializer < ActiveModel::Serializer
  attribute :id, key: :user_id
  attributes :first_name, :last_name, :focus_areas

  def focus_areas
    focus_areas = []
    object.focus_areas.each do |focus_area|
      focus_areas << FocusAreaSerializer.new(focus_area)
    end
    focus_areas
  end
end
