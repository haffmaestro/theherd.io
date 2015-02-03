module Reports
  class CreateHerdWeekly
    include Virtus.model
    
    attribute :herd, Herd
    attribute :year, String
    attribute :week, String

    def call
      @herd_weekly = herd.herd_weeklies.new
      herd.users.each do |user|
        create_user_weekly_service = Reports::CreateUserWeekly.new(user: user)
        user_weekly = create_user_weekly_service.call
        user_weekly.herd_weekly = @herd_weekly
        user_weekly.save!
      end
      @herd_weekly.year = year.to_i
      @herd_weekly.week = week.to_i
      @herd_weekly.save!
      @herd_weekly
    end

  end
end