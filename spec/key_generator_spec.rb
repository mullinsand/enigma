require 'key_generator'

describe KeyGenerator do
  it 'generates a random 5 digit key as a string' do
    key = generate_key
    expect(key.length).to eq(5)
    expect(key).to be_instance_of(String)
  end
end