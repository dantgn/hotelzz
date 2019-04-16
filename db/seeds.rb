# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).

# Some dummy data to start to play around with the app locally

# create hotels
Hotel.create(
  [
    { name: 'The Grand Hotel Budapest' },
    { name: 'Tarraco Hotel' }
  ]
)

# room type samples
room_types = [
  { name: 'Single bed with private bath', occupancy_limit: 1 },
  { name: '1 Queen-size bed with private bath', occupancy_limit: 2 },
  { name: '2 King-size bed with private bath', occupancy_limit: 4 }
]

Hotel.all.each do |hotel|
  # Add room types to hotels
  hotel.room_types.create(room_types)

  # Add hotel rooms to hotels
  hotel.room_types.each_with_index do |room_type, index|
    hotel.hotel_rooms.create(room_type_id: room_type.id, number: index + 1)
  end
end
Admin.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password') if Rails.env.development?AdminUser.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password') if Rails.env.development?