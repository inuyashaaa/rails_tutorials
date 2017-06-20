User.create! name: "illuminati", email: "huymanhtmhp@gmail.com",
  password: "manhtmhp123", password_confirmation: "manhtmhp123", is_admin: true,
  activated: true, activated_at: Time.zone.now

Settings.user.seed_record.times do |n|
  name = Faker::Name.name
  email = "example-#{n+1}@railstutorial.org"
  password = "123456"
  User.create! name: name, email: email, password: password,
    password_confirmation: password, activated: true, activated_at: Time.zone.now
end

users = User.order(:created_at).take Settings.microposts.user_taked
(Settings.microposts.seed_record).times do
  content = Faker::Lorem.sentence Settings.microposts.sentence
  users.each{|user| user.microposts.create!(content: content)}
end

users = User.all
user = users.first
following = users[Settings.follow.min_following..Settings.follow.max_following]
followers = users[Settings.follow.min_followers..Settings.follow.max_followers]
following.each{|followed| user.follow followed}
followers.each{|follower| follower.follow user}
