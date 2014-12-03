class Herd < ActiveRecord::Base
  validates :name, presence: true, uniqueness: true
  validates :subdomain, presence: true, uniqueness: true,length: {maximum: 25 }, subdomain_format: true

  has_many :users, -> {order 'first_name ASC'}
  has_many :herd_weeklies

  def self.find_last_weekly(herd, user)
    if record = herd.herd_weeklies.last
      if record.users.exists?(id: user.id)
        record
      else
        service = Reports::CreateUserWeekly.new(user: user)
        user_weekly = service.call
        user_weekly.herd_weekly = record
        user_weekly.save
        record
      end
    else
      service = Reports::CreateHerdWeekly.new(herd: herd)
      record = service.call
      record
    end
  end
end
