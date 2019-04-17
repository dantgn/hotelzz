Fabricator(:booking) do
  guest       { Fabricate(:guest) }
  hotel       { Fabricate(:hotel) }
  room_type   { Fabricate(:room_type) }
  check_in    { 1.day.from_now }
  check_out   { 31.days.from_now }
  status      'paid'
end