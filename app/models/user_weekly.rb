class UserWeekly < ActiveRecord::Base
  belongs_to :herd_weekly
  belongs_to :user
  has_many :sections, -> {order 'name ASC'}
end
