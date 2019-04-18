Fabricator(:payment) do
  booking             { Fabricate(:booking) }
  status              'paid'
  charge_id           'ch_12345'
end
