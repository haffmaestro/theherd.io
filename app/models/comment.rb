class Comment < ActiveRecord::Base
  include PublicActivity::Common
  belongs_to :section
  belongs_to :user

  validates :body, presence: true
end
