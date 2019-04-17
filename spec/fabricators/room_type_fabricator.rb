Fabricator(:room_type) do
  hotel             { Fabricate(:hotel) }
  name              '1 King-Size bed with private bathroom'
  occupancy_limit   2
  number_of_rooms   4
end
