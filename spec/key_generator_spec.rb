require 'key_generator'

describe KeyGenerator do
  let(:enigma) {Enigma.new}
  it 'generates a random 5 digit key as a string' do
    key = enigma.generate_key
    expect(key.length).to eq(5)
    expect(key).to be_instance_of(String)
    require 'pry'; binding.pry
  end
end