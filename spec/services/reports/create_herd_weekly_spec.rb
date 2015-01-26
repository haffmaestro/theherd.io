 require 'rails_helper'

 RSpec.describe Reports::CreateHerdWeekly, :type => :service do

  describe "call" do
    context "with 4 users" do
      let(:herd) {create(:herd_with_4)}

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
        expect(herd_weekly.user_weeklies.count).to eq(herd.users.count)
      end

      it "persists" do
        herd_weekly = create_herd_weekly
        expect(herd_weekly.persisted?).to be true
      end

      it "the year_week_id method works" do
        herd_weekly = create_herd_weekly
        expect(herd_weekly.year_week_id).to eq("#{Date.today.year}-#{Date.today.cweek}")
      end

      it "finds the herd_weekly with find_for_week" do
        herd_weekly = create_herd_weekly
        expect(HerdWeekly.all.count).to be 1
        expect(HerdWeekly.find_for_week(herd, herd_weekly.year_week_id)).to eq herd_weekly
      end

      it "creates a new HerdWeekly if not found" do
        expect(HerdWeekly.all.count).to be 0
        herd_weekly = HerdWeekly.find_for_week(herd, "#{Date.today.year}-#{Date.today.cweek}")
        expect(herd_weekly.class).to be HerdWeekly.new.class 
      end
    end

    context "with 1 user" do
      let(:herd) {create(:herd_with_1)}
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

      it "has one UserWeekly" do
        herd_weekly = create_herd_weekly
        expect(herd_weekly.user_weeklies.count).to eq 1
      end

      it "persists" do
        herd_weekly = create_herd_weekly
        expect(herd_weekly.persisted?).to be true
      end

      it "the year_week_id method works" do
        herd_weekly = create_herd_weekly
        expect(herd_weekly.year_week_id).to eq("#{Date.today.year}-#{Date.today.cweek}")
      end

      it "finds the herd_weekly with find_for_week" do
        herd_weekly = create_herd_weekly
        expect(HerdWeekly.all.count).to be 1
        expect(HerdWeekly.find_for_week(herd, herd_weekly.year_week_id)).to eq herd_weekly
      end

      it "creates a new HerdWeekly if not found" do
        expect(HerdWeekly.all.count).to be 0
        herd_weekly = HerdWeekly.find_for_week(herd, "#{Date.today.year}-#{Date.today.cweek}")
        expect(herd_weekly.class).to be HerdWeekly.new.class 
      end

    end

  end
  
end
