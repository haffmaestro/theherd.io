class CommentSerializer < ActiveModel::Serializer
  attributes :id, :section_id, :body, :date, :user_id, :first_name, :section

  def first_name
  	object.user.first_name
  end

  def date
  	object.created_at.strftime('%a, %d %b %y %H:%M')
  end

  def section
    SectionSerializer.new(object.section, root: false)
  end
end
