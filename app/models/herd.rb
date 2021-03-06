class Herd < ActiveRecord::Base
  has_paper_trail
  validates :name, presence: true, uniqueness: true
  validates :subdomain, presence: true, uniqueness: true,length: {maximum: 25 }, subdomain_format: true

  has_many :users, -> {order 'first_name ASC'}, dependent: :destroy
  has_many :herd_weeklies, dependent: :destroy
  after_create :create_first_herd_weekly

  #This method is no longer used, look in HerdWeekly
  def self.find_last_weekly(herd, user)
    logger.error("=====================================================")
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

  def create_first_herd_weekly
    service = Reports::CreateHerdWeekly.new(herd: self, year: Date.today.year.to_s, week: Date.today.cweek.to_s)
    service.call
  end



end
