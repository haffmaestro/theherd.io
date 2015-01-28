class UserWeekly < ActiveRecord::Base
  include PublicActivity::Common
  belongs_to :herd_weekly
  belongs_to :user
  has_many :sections, -> {order 'name ASC'}, dependent: :destroy
end
