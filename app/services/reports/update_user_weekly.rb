module Reports
  class UpdateUserWeekly
    attr_accessor :user

    def initialize(user)
      @user = user
    end

    def call
      user_weekly = @user.user_weeklies.last
      user_weekly.sections.each do |section|
        if section.focus_area
          section.name = section.focus_area.name
          section.save
        else
          section.destroy
        end
      end
      @user.focus_areas.each do |focus_area|
        if focus_area.sections.count == 0
          section = user_weekly.sections.new(name: focus_area.name)
          section.focus_area = focus_area
          section.save!
        end
      end
      user_weekly.save!
    end



  end
end