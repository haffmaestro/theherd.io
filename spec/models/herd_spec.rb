require 'rails_helper'

RSpec.describe Herd, :type => :model do
  describe "Validations" do
    def valid_attributes
      attributes_for :herd
    end
    it "validates name presence" do
      herd = Herd.new(subdomain: "lol")
      herd.save
      expect(herd.errors.messages).to have_key(:name)
    end

    it "validates name uniqueness" do
      herd = Herd.new(name: "james", subdomain: "james")
      herd2 = Herd.new(name: "james", subdomain: "james")
      herd.save
      herd2.save
      expect(herd2.errors.messages).to have_key(:name)
    end

    it "validates subdomain presence" do
      herd = Herd.new(name: "lol")
      herd.save
      expect(herd.errors.messages).to have_key(:subdomain)
    end

    it "validates subdomain uniqueness" do
      herd = Herd.new(name: "james", subdomain: "james")
      herd2 = Herd.new(name: "james", subdomain: "james")
      herd.save
      herd2.save
      expect(herd2.errors.messages).to have_key(:subdomain)
    end

    it "validates subdomain validity" do
      herd = Herd.new(name: "fucker", subdomain: "lol..........")
      herd.save
      expect(herd.errors.messages).to have_key(:subdomain)
    end

    it "validates subdomain length" do
      herd = Herd.new(name: 'james', subdomain: "oooooooooooooooooooooooooooooooooooooooooooooooo")
      herd.save
      expect(herd.errors.messages).to have_key(:subdomain)
    end
  end
end