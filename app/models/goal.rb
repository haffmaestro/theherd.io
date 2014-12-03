class Goal < ActiveRecord::Base
  belongs_to :focus_area
  validates :body, :due_date, presence: true

  before_create :set_done_false

  def set_done_false
  	self.done = false
    true
  end

  def self.find_for_herd(herd)
  	goals = {}
  	herd.users
  end

end
