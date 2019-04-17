# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).

# Some dummy data to start to play around with the app locally

return unless Rails.env.development?

# create hotels
Hotel.create!(
  [
    { name: 'The Grand Hotel Budapest' },
    { name: 'Tarraco Hotel' }
  ]
)

# room type samples
room_types = [
  {
    name: 'Single bed with private bath',
    occupancy_limit: 1,
    number_of_rooms: 4
  },
  {
    name: '1 Queen-size bed with private bath',
    occupancy_limit: 2,
    number_of_rooms: 2
  },
  {
    name: '2 King-size bed with private bath',
    occupancy_limit: 4,
    number_of_rooms: 1
  }
]

Hotel.all.each do |hotel|
  # Add room types to hotels
  hotel.room_types.create!(room_types)

  # Add hotel rooms to hotels
  hotel.room_types.each_with_index do |room_type, index|
    hotel.hotel_rooms.create!(room_type_id: room_type.id, number: index + 1)
  end
end

# Admin user for Admin Panel
AdminUser.create!(
  email: 'admin@example.com',
  password: 'password',
  password_confirmation: 'password'
)

# Guest to create a booking
guest = Guest.create!(
  email: 'guest@example.com',
  password: 'password',
  password_confirmation: 'password',
  first_name: 'John',
  last_name: 'Snow'
)

# create Booking sample
hotel = Hotel.first
room_type = hotel.room_types.first
Booking.create!(
  guest: guest,
  hotel: hotel,
  room_type: room_type,
  check_in: 1.day.from_now,
  check_out: 31.days.from_now
)

# create room prices sample

RoomType.all.each do |room|
  12.times do |i|
    room.room_type_prices.create!(month: (i + 1), currency: 'usd', amount: 1200)
  end
end
