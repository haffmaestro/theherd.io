class Herd < ActiveRecord::Base
  validates :name, presence: true, uniqueness: true
  validates :subdomain, presence: true, uniqueness: true,length: {maximum: 25 }, subdomain_format: true

  has_many :users
  has_many :herd_weeklies

  def self.find_last_weekly(herd)

    if record = herd.herd_weeklies.last
      record
    else
      service = Reports::CreateHerdWeekly.new(herd: herd)
      record = service.call
      record
    end
  end
end
