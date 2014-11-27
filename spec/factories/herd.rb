FactoryGirl.define do
  factory :herd do
    name {Faker::Company.name}
    subdomain {Faker::Address.city.downcase.split(" ").join}

    factory :herd_with_4 do
      after(:create) do |herd|
        4.times {create(:user, herd: herd)}
      end
    end

    factory :herd_with_1 do
      after(:create) do |herd|
        create(:user, herd: herd)
      end
    end
  end
end