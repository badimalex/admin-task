User.create!([
  {email: 'user@example.com', password: "123456"},
  {email: 'admin@example.com', password: "123456", admin: true}
])
