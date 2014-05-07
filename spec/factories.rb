FactoryGirl.define do
  factory :user do
    name     "ExampleUser"
    email    "user@example.com"
    password "UserTest"
    password_confirmation "UserTest"
  end
end