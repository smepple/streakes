FactoryGirl.define do
  factory :user do
    sequence :email do |n|
      "testuser#{n}@example.com"
    end
    password "foobarbaz"
  end
end