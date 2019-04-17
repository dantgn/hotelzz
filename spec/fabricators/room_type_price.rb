Fabricator(:room_type_price) do
  room_type   { Fabricate(:room_type) }
  amount      1200
  currency    'usd'
  month       1
end
