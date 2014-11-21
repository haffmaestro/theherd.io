FactoryGirl.define do
  factory :herd do
    name Faker::Company.name
    subdomain Faker::Company.suffix
  end
end