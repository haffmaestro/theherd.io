require 'rails_helper'

RSpec.describe Reports::CreateUserWeekly, :type => :service do
  describe "call" do
    let(:user) {create(:user)}

    def create_user_weekly 
      service = Reports::CreateUserWeekly.new(user: user)
      user_weekly = service.call
      return user_weekly
    end

    it "creates a UserWeekly object" do
      user_weekly = create_user_weekly
      expect(user_weekly.class).to eq(UserWeekly.new.class)
    end

    it "it belongs to the user" do
      user_weekly = create_user_weekly
      expect(user_weekly.user).to eq(user)
    end


    it "has a section for each of the users focus_areas" do
      user_weekly = create_user_weekly
      user_weekly.sections.each do |section|
        expect(user.focus_areas.exists?(name: section.name)).to be true
      end
    end

    it "persists" do
      user_weekly = create_user_weekly
      expect(user_weekly.persisted?).to be(true)
    end


  end
end
