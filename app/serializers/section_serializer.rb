class SectionSerializer < ActiveModel::Serializer
  attributes :user_weekly_id, :name, :body

  # TODO: has_many :comments, :weekly_tasks
end
