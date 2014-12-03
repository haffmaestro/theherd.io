class UserGoalsSerializer < ActiveModel::Serializer
  attribute :id, key: :user_id
  attributes :first_name, :last_name
  
  has_many :focus_areas

  def focus_areas
    areas = []
    object.focus_areas.each do |focus_area|
      areas << FocusAreaSerializer.new(focus_area)
    end
    areas
  end
end
