require 'enigma'

describe Enigma do
  let(:enigma) {Enigma.new}

  it 'exists and has attributes' do
    expect(enigma).to be_instance_of(Enigma)
    expect(enigma.message).to eq(nil)
    expect(enigma.given_key).to eq(nil)
    expect(enigma.given_date).to eq(nil)
  end

  it 'encrypts a message when given a key and date' do
    allow(enigma).to receive(:encrypt_message).and_return("keder ohulw")
    expect(enigma.encrypt("hello world", "02715", "040895")).to eq( {
          encryption: "keder ohulw",
          key: "02715",
          date: "040895"
        } )
    expect(enigma.message).to eq("hello world")
    expect(enigma.given_key).to eq("02715")
    expect(enigma.given_date).to eq("040895")
  end

  it 'assigns message, key, and date attributes based on input' do
    allow(enigma).to receive(:encrypt_message).and_return("keder ohulw")
    enigma.encrypt("hello world", "02715", "040895")
    expect(enigma.message).to eq("hello world")
    expect(enigma.given_key).to eq("02715")
    expect(enigma.given_date).to eq("040895")
  end

  it 'determines the key shift for A key' do
    allow(enigma).to receive(:encrypt_message).and_return("keder ohulw")
    enigma.encrypt("hello world", "02715", "040895")
    expect(enigma.a_key_shift).to eq(2)
  end

  it 'determines the key shift for B key' do
    allow(enigma).to receive(:encrypt_message).and_return("keder ohulw")
    enigma.encrypt("hello world", "02715", "040895")
    expect(enigma.b_key_shift).to eq(27)
  end

  it 'determines the key shift for C key' do
    allow(enigma).to receive(:encrypt_message).and_return("keder ohulw")
    enigma.encrypt("hello world", "02715", "040895")
    expect(enigma.c_key_shift).to eq(71)
  end

  it 'determines the key shift for D key' do
    allow(enigma).to receive(:encrypt_message).and_return("keder ohulw")
    enigma.encrypt("hello world", "02715", "040895")
    expect(enigma.d_key_shift).to eq(15)
  end
end