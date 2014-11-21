class Section < ActiveRecord::Base
  belongs_to :user_weekly
  belongs_to :focus_area

  validates :name, :body, presence: true
end
