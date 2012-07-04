FactoryGirl.define do
  factory :user do
    sequence(:name){|n| "foo#{n}"}
    password "foobar"
    email { "#{name}@example.com" }
    admin false

    factory :admin do
      admin true
    end
  end
  
  factory :filter do
    sequence(:name){|n| "Criterion group #{n}"}
  end
  
  factory :criterion do
    sequence(:name){|n| "Criterion #{n}"}
    filter
  end
  
  factory :article do
    name "Foo"
    content "Bar"
    user
  end
end