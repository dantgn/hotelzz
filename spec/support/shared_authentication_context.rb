RSpec.shared_examples('when jwt authentication fails') do
  let(:expected_response) do
    { 'error' => '401 Unauthorized' }
  end

  it 'returns authorization error' do
    subject

    expect(JSON.parse(response.body)).to eq(expected_response)
    expect(response.status).to eq(401)
  end
end