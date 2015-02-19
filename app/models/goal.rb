class Goal < ActiveRecord::Base
  include PublicActivity::Common
  belongs_to :focus_area
  validates :body, :due_date, presence: true

  before_create :set_done_false

  def set_done_false
  	self.done = false
    true
  end

end
