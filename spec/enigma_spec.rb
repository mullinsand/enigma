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

  it 'encrypts a message' do
    allow(enigma).to receive(:generate_key).and_return("02715")
    allow(Time).to receive(:new).and_return(Time.new(1995, 8, 4))

    expect(enigma.encrypt("hello world", nil, nil)).to eq( {
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

  it 'decrypts a ciphertext when given just a key' do
    allow(Time).to receive(:new).and_return(Time.new(1995, 8, 4))
    expect(enigma.decrypt("keder ohulw", "02715", nil)).to eq( {
      decryption: "hello world",
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
#figure out positions for " end" in the message to determine ABCD shifts
#total length of message - 3 for " "
    expect(enigma.space_position).to eq(6)
    expect(enigma.e_position).to eq(7)
    expect(enigma.n_position).to eq(8)
    expect(enigma.d_position).to eq(9)
  end

  it 'can handle multiple working keys' do
    allow(enigma).to receive(:all_matched_key_shifts).and_return({ 
      alpha: ["02", "01"],
      beta: ["27", "12"],
      gamma: ["23", "71"],
      delta: ["34", "15"]
    })
    expect(enigma.multiple_keys_scenario(enigma.all_matched_key_shifts)).to eq(["02715", "01234"])
  end

  it 'cracks!' do
    expect(enigma.crack("keder xgg", "040895")).to eq({
      decryption: "hello end",
      date: "040895",
      key: "02715"
      })
  end

  it 'makes an array of " end"' do
    expect(enigma.decrypted_end).to eq([" ", "e", "n", "d"])
  end

  it 'makes an array of the last four characters in the encrypted message' do
    @encrypted_message = enigma.encrypt("hello end", "02715", "040895")[:encryption]
    #keder xgg
    expect(enigma.encrypted_end).to eq([" ", "x", "g", "g"])
  end

  it 'makes an array of the shift type by position of the last four characters' do
    @encrypted_message = enigma.encrypt("hello end", "02715", "040895")[:encryption]
    #keder xgg
    expect(enigma.shift_type_end).to eq([2, 3, 0, 1])
  end

  it 'rotates the arrays to the proper order A,B,C,D' do
    @encrypted_message = enigma.encrypt("hello end", "02715", "040895")[:encryption]
    expect(enigma.rotate_to_abcd_order(enigma.encrypted_end)).to eq(["g", " ", "x", "g"])
  end

  it 'maps over an array to convert to index numbers' do
    @encrypted_message = enigma.encrypt("hello end", "02715", "040895")[:encryption]
    expect(enigma.convert_to_index(enigma.decrypted_end)).to eq([26, 4, 13, 3])
  end

  it 'maps over an array to convert to negative index numbers' do
    @encrypted_message = enigma.encrypt("hello end", "02715", "040895")[:encryption]
    expect(enigma.convert_to_negative_index(enigma.decrypted_end)).to eq([-26, -4, -13, -3])
  end

  it 'converts position to negative date shift' do
    @encrypted_message = enigma.encrypt("hello end", "02715", "040895")[:encryption]
    expect(enigma.convert_to_negative_date_shift(enigma.shift_type_end)).to eq([0, -2, -5, -1])

  end

  it 'combines positional elements in each array to get the key shift' do
    @encrypted_message = enigma.encrypt("hello end", "02715", "040895")[:encryption]
    expect(enigma.absolute_key_shift).to eq([0, 17, 15, 2])
  end

  it 'converts integer key shifts to strings' do
    expect(enigma.convert_key_to_string(0)).to eq("00")
    expect(enigma.convert_key_to_string(17)).to eq("17")
    expect(enigma.convert_key_to_string(15)).to eq("15")
    expect(enigma.convert_key_to_string(2)).to eq("02")
  end

  # it 'formats and orders the keys' do
  #   @encrypted_message = enigma.encrypt("hello end", "02715", "040895")[:encryption]
  #   expect(enigma.order_format_keys()).to eq(["02", "00", "17", "15"])
  # end

  it 'finds all other possible key shifts based on one key shift' do
    @encrypted_message = enigma.encrypt("hello end", "02715", "040895")[:encryption]
    expect(enigma.all_possible_key_shifts).to eq([
      ["02", "29", "56", "83"],
      ["00", "27", "54", "81"],
      ["17", "44", "71", "98"],
      ["15", "42", "69", "96"]
    ])
  end

  it 'converts all possible key shifts from array to a hash' do
    @encrypted_message = enigma.encrypt("hello end", "02715", "040895")[:encryption]
    expect(enigma.keys_by_shift).to eq( { 
      alpha: ["02", "29", "56", "83"],
      beta: ["00", "27", "54", "81"],
      gamma: ["17", "44", "71", "98"],
      delta: ["15", "42", "69", "96"]
    })
  end
#will need to be stumped for multiples
  it 'finds all matched beta keys' do
    @encrypted_message = enigma.encrypt("hello end", "02715", "040895")[:encryption]
    expect(enigma.beta_matched_keys).to eq(["27"])
  end

  it 'finds all matched gamma keys' do
    @encrypted_message = enigma.encrypt("hello end", "02715", "040895")[:encryption]
    allow(enigma).to receive(:matched_keys).and_return({beta: ["27"]})
    expect(enigma.gamma_matched_keys(enigma.matched_keys)).to eq(["71"])
  end

  it 'finds all matched alpha keys' do
    @encrypted_message = enigma.encrypt("hello end", "02715", "040895")[:encryption]
    allow(enigma).to receive(:matched_keys).and_return({beta: ["27"]})
    expect(enigma.alpha_matched_keys(enigma.matched_keys)).to eq(["02"])
  end

  it 'finds all matched delta keys' do
    @encrypted_message = enigma.encrypt("hello end", "02715", "040895")[:encryption]
    allow(enigma).to receive(:matched_keys).and_return({gamma: ["71"]})
    expect(enigma.delta_matched_keys(enigma.matched_keys)).to eq(["15"])
  end

  it 'all_matched_key_shifts' do
    @encrypted_message = enigma.encrypt("hello end", "02715", "040895")[:encryption]
    allow(enigma).to receive(:matched_keys).and_return({gamma: ["71"]})
    expect(enigma.all_matched_key_shifts).to eq({ 
      alpha: ["02"],
      beta: ["27"],
      gamma: ["71"],
      delta: ["15"]
    })
  end

  it 'can combine keys' do
    @encrypted_message = enigma.encrypt("hello end", "02715", "040895")[:encryption]
    expect(enigma.combined_key("02", "71", "15")).to eq("02715")
  end
end

