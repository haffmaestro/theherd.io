FactoryGirl.define do
  factory :herd do
    name {Faker::Company.name}
    subdomain {Faker::Address.city.downcase.split(" ").join}

    after(:create) do |herd|
      4.times {create(:user, herd: herd)}
    end
  end
end