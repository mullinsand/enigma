require 'enigma'

describe Enigma do
  let(:enigma) {Enigma.new}

  it 'exists and has attributes' do
    expect(enigma).to be_instance_of(Enigma)
    expect(enigma.message).to eq(nil)
    expect(enigma.given_key).to eq(nil)
    expect(enigma.given_date).to eq(nil)
    expect(enigma.encrypted_message).to eq(nil)
    expect(enigma.character_set).to eq(["a", "b", "c", "d", "e", "f", 
                                        "g", "h", "i", "j", "k", "l", 
                                        "m", "n", "o", "p", "q", "r", 
                                        "s", "t", "u", "v", "w", "x", 
                                        "y", "z", " "])
  end

  it 'encrypts a message when given a key and date' do
    expect(enigma.encrypt("hello world", "02715", "040895")).to eq( {
          encryption: "keder ohulw",
          key: "02715",
          date: "040895"
        } )
    expect(enigma.message).to eq("hello world")
    expect(enigma.given_key).to eq("02715")
    expect(enigma.given_date).to eq("040895")
  end

  xit 'encrypts a message' do
    allow(enigma).to receive(:key_generator).and_return("02715")
    allow(enigma).to receive(:given_date).and_return("040895")

    expect(enigma.encrypt("hello world")).to eq( {
          encryption: "keder ohulw",
          key: "02715",
          date: "040895"
        } )
    expect(enigma.message).to eq("hello world")
    expect(enigma.given_key).to eq("02715")
    expect(enigma.given_date).to eq("040895")
  end

  it 'decrypts a ciphertext when given a key and date' do
    expect(enigma.decrypt("keder ohulw", "02715", "040895")).to eq( {
          decryption: "hello world",
          key: "02715",
          date: "040895"
        } )
    
    expect(enigma.encrypted_message).to eq("keder ohulw")
    expect(enigma.given_key).to eq("02715")
    expect(enigma.given_date).to eq("040895")
  end

  xit 'decrypts a ciphertext when given a just a key' do
    allow(enigma).to receive(:given_date).and_return("040895")
    expect(enigma.decrypt("keder ohulw", "02715")).to eq( {
      encryption: "hello world",
      key: "02715",
      date: "040895"
    } )
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

  it 'determines encrypted character for A, B, C, D keys' do
    allow(enigma).to receive(:encrypt_message).and_return("keder ohulw")
    enigma.encrypt("hello world", "02715", "040895")

    expect(enigma.a_shift("h")).to eq("k")
    expect(enigma.b_shift("e")).to eq("e")
    expect(enigma.c_shift("l")).to eq("d")
    expect(enigma.d_shift("l")).to eq("e")
  end

  describe 'sorts the message' do

  end

  it 'encrypts the message' do
    enigma.encrypt("hello ", "02715", "040895")
      enigma.message = "h"
      expect(enigma.encrypt_message).to eq("k")

      enigma.message = "he"
      expect(enigma.encrypt_message).to eq("ke")

      enigma.message = "hel"
      expect(enigma.encrypt_message).to eq("ked")

      enigma.message = "hell"
      expect(enigma.encrypt_message).to eq("kede")

      enigma.message = "hello world"
      expect(enigma.encrypt_message).to eq("keder ohulw")
  end

  it 'determines decrypted character for A, B, C, D keys' do
    enigma.encrypted_message = "keder ohulw"
    enigma.given_date = "040895"
    enigma.given_key = "02715"

    expect(enigma.reverse_a_shift("k")).to eq("h")
    expect(enigma.reverse_b_shift("e")).to eq("e")
    expect(enigma.reverse_c_shift("d")).to eq("l")
    expect(enigma.reverse_d_shift("e")).to eq("l")
  end

  it 'decrypts the message' do
    enigma.given_date = "040895"
    enigma.given_key = "02715"
    enigma.encrypted_message = "k"
    expect(enigma.decrypt_message).to eq("h")

    enigma.encrypted_message = "ke"
    expect(enigma.decrypt_message).to eq("he")

    enigma.encrypted_message = "ked"
    expect(enigma.decrypt_message).to eq("hel")

    enigma.encrypted_message = "kede"
    expect(enigma.decrypt_message).to eq("hell")

    enigma.encrypted_message = "keder ohulw"
    expect(enigma.decrypt_message).to eq("hello world")
  end
end

describe 'cracking some code' do
  let(:enigma) {Enigma.new}
  it 'figures out the end positions' do
    @encrypted_message = enigma.encrypt("hello end", "02715", "040895")[:encryption]
    #keder xgg
    @date = "040895"
#figure out positions for " end" in the message to determine ABCD shifts
#total length of message - 3 for " "
    expect(enigma.space_position).to eq(6)
    expect(enigma.e_position).to eq(7)
    expect(enigma.n_position).to eq(8)
    expect(enigma.d_position).to eq(9)
  end

  it 'assigns ABCD shifts as attributes for the space "e", "n", "d"' do
    @encrypted_message = enigma.encrypt("hello end", "02715", "040895")[:encryption]
    #keder xgg
    @date = "040895"
    enigma.assign_letter_shift(enigma.space_position)
    enigma.assign_letter_shift(enigma.e_position)
    enigma.assign_letter_shift(enigma.n_position)
    enigma.assign_letter_shift(enigma.d_position)
    @space_position_shift = :b_second
    @e_position_shift = :c_third
    @n_position_shift = :d_fourth
    @d_position_shift = :a_first
  end


  it 'determines ABCD shifts and shifts using just #date shift' do
    @encrypted_message = enigma.encrypt("hello end", "02715", "040895")[:encryption]
    #keder xgg
    @date = "040895"
    expect(enigma.date_shift((enigma.space_position), " ")).to eq(" ")
    expect(enigma.date_shift((enigma.e_position), "e")).to eq("g")
    expect(enigma.date_shift((enigma.n_position), "n")).to eq("s")
    expect(enigma.date_shift((enigma.d_position), "d")).to eq("e")
    # #2 key shift
    # #1 date shift
    # enigma.determine_a_key_shift
    # #27
    # #0
    # enigma.determine_b_key_shift
    # #71
    # #2
    # enigma.determine_c_key_shift
    # #15
    # #5
    # enigma.determine_d_key_shift
  end

  it 'determines key shift' do
    @encrypted_message = enigma.encrypt("hello end", "02715", "040895")[:encryption]
    #keder xgg
    @date = "040895"
    # " " to " " - 00, 27, 54, 81 B
    expect(enigma.possible_key_shifts(@encrypted_message[enigma.space_position - 1], enigma.date_shift(enigma.space_position, " "))).to eq(["00", "27", "54", "81"])
    # "g" to "x" - 17, 44, 71, 98 C
    expect(enigma.possible_key_shifts(@encrypted_message[enigma.e_position - 1], enigma.date_shift(enigma.e_position, "e"))).to eq(["17", "44", "71", "98"])
    # "s" to "g" - 15, 42, 69, 96 D
    expect(enigma.possible_key_shifts(@encrypted_message[enigma.n_position - 1], enigma.date_shift(enigma.n_position, "n"))).to eq(["15", "42", "69", "96"])
    #"e" to "g" - 02, 29, 56, 83 A
    expect(enigma.possible_key_shifts(@encrypted_message[enigma.d_position - 1], enigma.date_shift(enigma.d_position, "d"))).to eq(["02", "29", "56", "83"])
  end

  it 'it makes a hash of all possible_key_shifts by letter shift designation' do
    @encrypted_message = enigma.encrypt("hello end", "02715", "040895")[:encryption]
    #keder xgg
    @date = "040895"
    enigma.assign_letter_shift(enigma.space_position)
    enigma.assign_letter_shift(enigma.e_position)
    enigma.assign_letter_shift(enigma.n_position)
    enigma.assign_letter_shift(enigma.d_position)

    expect(enigma.key_shifts_by_letter).to eq( { 
      a_first: ["02", "29", "56", "83"],
      b_second: ["00", "27", "54", "81"],
      c_third: ["17", "44", "71", "98"],
      d_fourth: ["15", "42", "69", "96"]
    })
  end
  
  it '#potential_key_shifts' do
    @encrypted_message = enigma.encrypt("hello end", "02715", "040895")[:encryption]
    #keder xgg
    @date = "040895"
    enigma.assign_letter_shift(enigma.space_position)
    enigma.assign_letter_shift(enigma.e_position)
    enigma.assign_letter_shift(enigma.n_position)
    enigma.assign_letter_shift(enigma.d_position)
    expect(enigma.potential_key_shifts).to eq({ 
        a_first: ["02"],
        b_second: ["27"],
        c_third: ["71"],
        d_fourth: ["15"]
      })
  end

  it 'makes an array of all possible keys' do
    @encrypted_message = enigma.encrypt("hello end", "02715", "040895")[:encryption]
    #keder xgg
    @date = "040895"
    enigma.assign_letter_shift(enigma.space_position)
    enigma.assign_letter_shift(enigma.e_position)
    enigma.assign_letter_shift(enigma.n_position)
    enigma.assign_letter_shift(enigma.d_position)
    expect(enigma.list_of_possible_keys).to eq(["02715"])
  end

  it 'can handle multiple working keys' do
    allow(enigma).to receive(:potential_key_shifts).and_return({ 
      a_first: ["02", "01"],
      b_second: ["27", "12"],
      c_third: ["23", "71"],
      d_fourth: ["34", "15"]
    })
    expect(enigma.multiple_keys_scenario).to eq(["02715", "01234"])
  end

  it 'cracks!' do
    expect(enigma.crack("keder xgg", "040895")).to eq({
      decryption: "hello end",
      date: "040895",
      key: "02715"
      })
  end
end

