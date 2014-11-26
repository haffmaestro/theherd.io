require 'rails_helper'

RSpec.describe Reports::CreateHerdWeekly, :type => :service do

  describe "call" do
    let(:herd) {create(:herd)}

    def create_herd_weekly
      service = Reports::CreateHerdWeekly.new(herd: herd)
      herd_weekly = service.call
      return herd_weekly
    end

    it "creates a HerdWeekly object" do
      herd_weekly = create_herd_weekly
      expect(herd_weekly.class).to eq(HerdWeekly.new.class)
    end

    it "belongs to the herd" do
      herd_weekly = create_herd_weekly
      expect(herd_weekly.herd).to eq(herd)
    end

    it "has a UserWeekly for each user" do
      herd_weekly = create_herd_weekly
      herd_weekly.user_weeklies.each do |user_weekly|
        expect(herd.users.exists?(first_name: user_weekly.user.first_name)).to be true
      end
    end

    it "persists" do
      herd_weekly = create_herd_weekly
      expect(herd_weekly.persisted?).to be true
    end

    it "the year_week_id method works" do
      herd_weekly = create_herd_weekly
      expect(herd_weekly.year_week).to eq("#{Date.today.year}-#{Date.today.cweek}")
    end

    it "finds the herd_weekly with find_for_week" do
      herd_weekly = create_herd_weekly
      expect(HerdWeekly.all.count).to be 1
      expect(HerdWeekly.find_for_week(herd, herd_weekly.year_week)).to eq herd_weekly
    end

    it "creates a new HerdWeekly if not found" do
      expect(HerdWeekly.all.count).to be 0
      herd_weekly = HerdWeekly.find_for_week(herd, "#{Date.today.year}-#{Date.today.cweek}")
      expect(herd_weekly.class).to be HerdWeekly.new.class 
    end

  end
  
end
