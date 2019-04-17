Fabricator(:guest) do
  email       { sequence(:email) { |i| "user#{i}@example.com" } }
  password    'password'
  first_name  'John'
  last_name   'Snow'
end
