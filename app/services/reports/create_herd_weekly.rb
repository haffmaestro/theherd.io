class Reports::CreateHerdWeekly
  include Virtus.model
  
  attribute :herd, Herd

  def call
    @herd_weekly = herd.herd_weeklies.new
    herd.users.each do |user|
      create_user_weekly_service = Reports::CreateUserWeekly.new(user: user)
      user_weekly = create_user_weekly_service.call
      user_weekly.herd_weekly = @herd_weekly
      user_weekly.save!
    end
    @herd_weekly.save!
    @herd_weekly
  end

end