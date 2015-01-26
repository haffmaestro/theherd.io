class HerdWeekly < ActiveRecord::Base
  belongs_to :herd
  has_many :user_weeklies, dependent: :destroy
  has_many :users, through: :user_weeklies

  after_create :set_year_week

  def self.find_for_week(herd, year_week_id)
    if record = herd.herd_weeklies.where(year: year_week_id.split("-").first, week: year_week_id.split("-").last).first
      record
    else
      service = Reports::CreateHerdWeekly.new(herd: herd)
      record = service.call
      record
    end
  end

  def year_week_id
    "#{year}-#{week}"
  end

  private

  def set_year_week
    self.year = Date.today.year
    self.week = Date.today.cweek
    self.save
  end

end
