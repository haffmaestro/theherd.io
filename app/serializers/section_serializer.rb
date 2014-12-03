class SectionSerializer < ActiveModel::Serializer
  attributes :user_weekly_id, :name, :body, :id, :href
  has_many :weekly_tasks
  # TODO: has_many :comments, 
  # 
  def href
  	"##{object.name.downcase}"
  end
end