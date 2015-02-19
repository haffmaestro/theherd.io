class FocusArea < ActiveRecord::Base
  has_paper_trail
  belongs_to :user
  validates :name, presence: true
  has_many :goals
  has_many :sections

end
