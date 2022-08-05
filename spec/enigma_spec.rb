require 'enigma'

describe Enigma do
  let(:enigma) {Enigma.new}

  it 'exists and has attributes' do
    expect(enigma).to be_instance_of(Enigma)
    expect(enigma.message).to eq(nil)
    expect(enigma.given_key).to eq(nil)
    expect(enigma.given_date).to eq(nil)
    expect(enigma.character_set).to eq(["a", "b", "c", "d", "e", "f", 
                                        "g", "h", "i", "j", "k", "l", 
                                        "m", "n", "o", "p", "q", "r", 
                                        "s", "t", "u", "v", "w", "x", 
                                        "y", "z", " "])
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

  it 'squares the properly formatted date' do
    allow(enigma).to receive(:encrypt_message).and_return("keder ohulw")
    enigma.encrypt("hello world", "02715", "040895")
    expect(enigma.square_date).to eq(1672401025)
  end

  it 'determines the date shift for A key' do
    allow(enigma).to receive(:encrypt_message).and_return("keder ohulw")
    enigma.encrypt("hello world", "02715", "040895")
    expect(enigma.a_date_shift).to eq(1)
  end

  it 'determines the date shift for B key' do
    allow(enigma).to receive(:encrypt_message).and_return("keder ohulw")
    enigma.encrypt("hello world", "02715", "040895")
    expect(enigma.b_date_shift).to eq(0)
  end

  it 'determines the date shift for C key' do
    allow(enigma).to receive(:encrypt_message).and_return("keder ohulw")
    enigma.encrypt("hello world", "02715", "040895")
    expect(enigma.c_date_shift).to eq(2)
  end

  it 'determines the date shift for D key' do
    allow(enigma).to receive(:encrypt_message).and_return("keder ohulw")
    enigma.encrypt("hello world", "02715", "040895")
    expect(enigma.d_date_shift).to eq(5)
  end

  it 'determines final shifts for A, B, C, D keys' do
    allow(enigma).to receive(:encrypt_message).and_return("keder ohulw")
    enigma.encrypt("hello world", "02715", "040895")

    expect(enigma.a_final_shift).to eq(3)
    expect(enigma.b_final_shift).to eq(27)
    expect(enigma.c_final_shift).to eq(73)
    expect(enigma.d_final_shift).to eq(20)
  end
end