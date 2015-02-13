class Section < ActiveRecord::Base
  belongs_to :user_weekly
  belongs_to :focus_area
  has_many   :weekly_tasks, dependent: :destroy
  has_many   :comments, -> {order 'created_at ASC'}, dependent: :destroy
  delegate :year_week_id, to: :user_weekly
  validates :name, presence: true
end
