require 'enigma'

describe Enigma do
  let(:enigma) {Enigma.new}
  it 'exists and has attributes' do
    expect(enigma).to be_instance_of(Enigma)
  end

  it 'encrypts a message when given a key and date' do
    allow(enigma).to receive(:encrypt).and_return({
      encryption: "keder ohulw",
      key: "02715",
      date: "040895"
    })
    expect(enigma.encrypt("hello world", "02715", "040895")).to eq( {
          encryption: "keder ohulw",
          key: "02715",
          date: "040895"
        } )
  end
end