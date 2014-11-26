module Reports
  class CreateUserWeekly
    include Virtus.model

    attribute :user, User

    def call
      user_weekly = user.user_weeklies.new
      user.focus_areas.each do |area|
        section = user_weekly.sections.new(name: area.name)
        section.focus_area = area
        section.save!
      end
      user_weekly.save!
      return user_weekly
    end



  end
end