class UserWeekly < ActiveRecord::Base
  include PublicActivity::Common
  belongs_to :herd_weekly
  belongs_to :user
  has_many :sections, -> {order 'name ASC'}, dependent: :destroy

  def self.is_done?(user_weekly)
    done = false
    results = user_weekly.sections.all.map {|section| section.body != nil}
    done = !(results.include?(false))
    user_weekly.done = done
    user_weekly.save
    return done
  end
    
end
