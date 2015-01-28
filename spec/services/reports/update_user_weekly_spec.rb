require 'rails_helper'

RSpec.describe Reports::UpdateUserWeekly, :type => :service do
  describe "call" do
    let(:user) {create(:user)}

    def create_user_weekly 
      service = Reports::CreateUserWeekly.new(user: user)
      user_weekly = service.call
      return user_weekly
    end

    it "doesnt change anything if nothing changed" do
      user_weekly = create_user_weekly
      copy = user_weekly.attributes
      service = Reports::UpdateUserWeekly.new(user)
      service.call
      user_weekly.reload
      original = user_weekly.attributes
      expect(original).to eq(copy)
    end

    it "deletes sections" do
      user_weekly = create_user_weekly
      user.focus_areas.find_by_name("Social").destroy
      user.focus_areas.find_by_name("Professional").destroy
      user.reload
      service = Reports::UpdateUserWeekly.new(user)
      service.call
      user_weekly.reload
      user_weekly.sections.each do |section|
        expect(user.focus_areas.exists?(name: section.name)).to be true
      end
    end


    it "adds sections" do
      user_weekly = create_user_weekly
      user.focus_areas.new(name: "Gardening").save
      user.focus_areas.new(name: "Meditation").save
      user.reload
      service = Reports::UpdateUserWeekly.new(user)
      service.call
      user_weekly.reload
      user_weekly.sections.each do |section|
        expect(user.focus_areas.exists?(name: section.name)).to be true
      end
    end

    it "it updates changed sections" do
      user_weekly = create_user_weekly
      user.focus_areas.find_by_name("Spiritual").update(name: "Gardening")
      user.focus_areas.find_by_name("Professional").update(name: "Meditation")
      user.reload
      service = Reports::UpdateUserWeekly.new(user)
      service.call
      user_weekly.reload
      user_weekly.sections.each do |section|
        expect(user.focus_areas.exists?(name: section.name)).to be true
      end
      expect(user_weekly.sections.exists?(name: "Gardening")).to be true
      expect(user_weekly.sections.exists?(name: "Meditation")).to be true
    end

    it 'returns true when successful' do
      user_weekly = create_user_weekly
      user.focus_areas.find_by_name("Spiritual").update(name: "Gardening")
      user.focus_areas.find_by_name("Professional").update(name: "Meditation")
      user.reload
      service = Reports::UpdateUserWeekly.new(user)
      expect(service.call).to be true
    end

  end
end
