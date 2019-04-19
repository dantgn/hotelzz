Fabricator(:hotel_manager) do
  email       { sequence(:email) { |i| "user#{i}@example.com" } }
  password    'password'
end
