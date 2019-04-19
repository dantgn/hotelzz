Fabricator(:hotel) do
  name 'default hotel'
  hotel_manager { Fabricate(:hotel_manager) }
end
