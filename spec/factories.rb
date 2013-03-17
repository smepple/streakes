FactoryGirl.define do
  
  factory :user do
    sequence :email do |n|
      "testuser#{n}@example.com"
    end
    password "foobarbaz"
  end

  factory :goal do
    user
    description "Get shit done!"
  end
end