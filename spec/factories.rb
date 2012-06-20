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
  
  factory :tgroup do
    sequence(:name){|n| "Tag group #{n}"}
  end
  
  factory :tag do
    sequence(:name){|n| "Tag #{n}"}
    tgroup
  end
  
  factory :article do
    name "Foo"
    content "Bar"
    user
  end
end