RSpec.describe Hash do
  it 'is used by RSpec for metadata', :fast do |example|
    expect(example.metadata).to include(fast: true)
  end
end
