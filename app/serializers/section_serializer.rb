class SectionSerializer < ActiveModel::Serializer
  attributes :user_weekly_id, :name, :body
  has_many :weekly_tasks
  # TODO: has_many :comments, :weekly_tasks
end
