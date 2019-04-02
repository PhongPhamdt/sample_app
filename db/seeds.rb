User.create!(name: "Marvelous",
             email: "marvelous@hmail.com",
             password: "hihihi",
             password_confirmation: "hihihi",
             gender: "male",
             date_of_birth: "31-03-1998",
             admin: true)

99.times do |n|
  name  = Faker::Name.name
  gender = "male"
  date_of_birth = Faker::Date.birthday(18, 65)
  email = "example-#{n+1}@railstutorial.org"
  password = "password"
  User.create!(name: name,
               email: email,
               password: password,
               password_confirmation: password,
               gender: gender,
               date_of_birth: date_of_birth)
end

users = User.order(:created_at).take(6)

50.times do
  content = Faker::Lorem.sentence(5)
  users.each { |user| user.microposts.create!(content: content) }
end
