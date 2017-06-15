User.create! name: "illuminati", email: "huymanhtmhp@gmail.com",
  password: "manhtmhp123", password_confirmation: "manhtmhp123", is_admin: true,
  activated: true, activated_at: Time.zone.now

99.times do |n|
  name = Faker::Name.name
  email = "example-#{n+1}@railstutorial.org"
  password = "123456"
  User.create! name: name, email: email, password: password,
    password_confirmation: password, activated: true, activated_at: Time.zone.now
end
