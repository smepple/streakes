FactoryGirl.define do
  factory :event do
    target
    description "Did some awesome shit"
    completed_at Time.now
  end
end
