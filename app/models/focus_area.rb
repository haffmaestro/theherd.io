class FocusArea < ActiveRecord::Base
  belongs_to :user
  validates :name, presence: true
  has_many :goals
  has_many :sections
end
