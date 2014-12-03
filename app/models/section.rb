class Section < ActiveRecord::Base
  belongs_to :user_weekly
  belongs_to :focus_area
  has_many   :weekly_tasks
  has_many   :comments, -> {order 'created_at ASC'}

  validates :name, presence: true
end
