FactoryGirl.define do
  sequence :email do |n|
    "thisis#{n}crazy@example.com"
  end
end