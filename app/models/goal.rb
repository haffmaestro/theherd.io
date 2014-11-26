class Goal < ActiveRecord::Base
  belongs_to :focus_area
  validates :body, :due_date, presence: true
end
