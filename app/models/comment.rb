class Comment < ActiveRecord::Base
  belongs_to :section
  belongs_to :user

  validates :body, presence: true
end
