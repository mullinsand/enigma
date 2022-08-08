require_relative 'key_generator'

class Enigma
  include KeyGenerator
  attr_accessor :message,
              :given_key,
              :given_date,
              :character_set,
              :encrypted_message

  def initialize
    #component_creation
    #CLI Class
    #run CLI method
      #Input (encryption, decryption, crack)
      #Sends info onto crypto class
      #Outputs final stuff
    #Enigma Class
    @message = nil
    @given_key = nil
    @given_date = nil
    @encrypted_message = nil
    @character_set = ["a", "b", "c", "d", "e", "f", 
                      "g", "h", "i", "j", "k", "l", 
                      "m", "n", "o", "p", "q", "r", 
                      "s", "t", "u", "v", "w", "x", 
                      "y", "z", " "]
    @space_position_shift = nil
    @e_position_shift = nil
    @n_position_shift = nil
    @d_position_shift = nil
  end

  def encrypt(message, given_key = generate_key, given_date = Time.new.strftime("%d%m%y"))
    @message = message
    @given_key = given_key
    @given_date = given_date
    {
      encryption: encrypt_message,
      key: @given_key,
      date: @given_date
    }
  end

  def decrypt(ciphertext, given_key, given_date = Time.new.strftime("d%m%y"))
    @encrypted_message = ciphertext
    @given_key = given_key
    @given_date = given_date
    {
      decryption: decrypt_message,
      key: @given_key,
      date: @given_date
    }
  end

  def a_key_shift
    @given_key[0..1].to_i
  end

  def b_key_shift
    @given_key[1..2].to_i
  end

  def c_key_shift
    @given_key[2..3].to_i
  end

  def d_key_shift
    @given_key[3..4].to_i
  end

  def square_date
    @given_date.to_i**2
  end

  def a_date_shift
    square_date.digits[3]
  end

  def b_date_shift
    square_date.digits[2]
  end

  def c_date_shift
    square_date.digits[1]
  end

  def d_date_shift
    square_date.digits[0]
  end

  def a_final_shift
    a_key_shift + a_date_shift
  end

  def b_final_shift
    b_key_shift + b_date_shift
  end

  def c_final_shift
    c_key_shift + c_date_shift
  end

  def d_final_shift
    d_key_shift + d_date_shift
  end

  def a_shift(character)
    @character_set[(@character_set.index(character) + a_final_shift) % 27]
  end

  def b_shift(character)
    @character_set[(@character_set.index(character) + b_final_shift) % 27]
  end

  def c_shift(character)
    @character_set[(@character_set.index(character) + c_final_shift) % 27]
  end

  def d_shift(character)
    @character_set[(@character_set.index(character) + d_final_shift) % 27]
  end

  def reverse_a_shift(character)
    @character_set[(@character_set.index(character) - a_final_shift) % 27]
  end

  def reverse_b_shift(character)
    @character_set[(@character_set.index(character) - b_final_shift) % 27]
  end

  def reverse_c_shift(character)
    @character_set[(@character_set.index(character) - c_final_shift) % 27]
  end

  def reverse_d_shift(character)
    @character_set[(@character_set.index(character) - d_final_shift) % 27]
  end
  
  def sort_by_position(character)

  end

  def encrypt_message
    position = 0
    @encrypted_message = @message.split("").map do |character|
      position += 1
      if !@character_set.include?(character)
        character
      elsif position % 4 == 1
        a_shift(character)
      elsif position % 4 == 2
        b_shift(character)
      elsif position % 4 == 3
        c_shift(character)
      elsif position % 4 == 0
        d_shift(character)
      end
    end.join
  end

  def decrypt_message
    position = 0
    @message = @encrypted_message.split("").map do |character|
      position += 1
      if !@character_set.include?(character)
        character
      elsif position % 4 == 1
        reverse_a_shift(character)
      elsif position % 4 == 2
        reverse_b_shift(character)
      elsif position % 4 == 3
        reverse_c_shift(character)
      elsif position % 4 == 0
        reverse_d_shift(character)
      end
    end.join
  end

  def space_position
    @encrypted_message.length - 3
  end

  def e_position
    @encrypted_message.length - 2
  end

  def n_position
    @encrypted_message.length - 1
  end

  def d_position
    @encrypted_message.length
  end

  def date_shift(position, character)
    if position % 4 == 1 #A shift
      @character_set[(@character_set.index(character) + square_date.digits[3]) % 27]
    elsif position % 4 == 2 #B shift
      @character_set[(@character_set.index(character) + square_date.digits[2]) % 27]
    elsif position % 4 == 3 #C shift
      @character_set[(@character_set.index(character) + square_date.digits[1]) % 27]
    elsif position % 4 == 0 #D shift
      @character_set[(@character_set.index(character) + square_date.digits[0]) % 27]
    end
  end

  def possible_key_shifts(encrypted_character, date_shifted_character)
    raw_key_shift = @character_set.index(encrypted_character) - @character_set.index(date_shifted_character)
    possible_key_shifts = []
    raw_key_shift += 27 if raw_key_shift < 0
    raw_key_shift.to_s.length == 1 ? key_shift_str = "0" + raw_key_shift.to_s : key_shift_str = raw_key_shift.to_s
    possible_key_shifts << key_shift_str
    until raw_key_shift > 100
      raw_key_shift += 27
      raw_key_shift.to_s.length == 1 ? key_shift_str = "0" + raw_key_shift.to_s : key_shift_str = raw_key_shift.to_s
      possible_key_shifts << key_shift_str if raw_key_shift < 100
    end
    possible_key_shifts
  end

  def assign_letter_shift(end_position)
        position = end_position
    if position % 4 == 1 #A shift
      if end_position == space_position
        @space_position_shift = :a_first
      elsif end_position == e_position
        @e_position_shift = :a_first
      elsif end_position == n_position
        @n_position_shift = :a_first
      elsif end_position == d_position
        @d_position_shift = :a_first
      end
    elsif position % 4 == 2 #B shift
      if end_position == space_position
        @space_position_shift = :b_second
      elsif end_position == e_position
        @e_position_shift = :b_second
      elsif end_position == n_position
        @n_position_shift = :b_second
      elsif end_position == d_position
        @d_position_shift = :b_second
      end
    elsif position % 4 == 3 #C shift
      if end_position == space_position
        @space_position_shift = :c_third
      elsif end_position == e_position
        @e_position_shift = :c_third
      elsif end_position == n_position
        @n_position_shift = :c_third
      elsif end_position == d_position
        @d_position_shift = :c_third
      end
    elsif position % 4 == 0 #D shift
      if end_position == space_position
        @space_position_shift = :d_fourth
      elsif end_position == e_position
        @e_position_shift = :d_fourth
      elsif end_position == n_position
        @n_position_shift = :d_fourth
      elsif end_position == d_position
        @d_position_shift = :d_fourth
      end
    end
  end

  def key_shifts_by_letter
    keys_by_letter = Hash.new
    keys_by_letter[@space_position_shift] = possible_key_shifts(@encrypted_message[space_position - 1], date_shift(space_position, " "))
    keys_by_letter[@e_position_shift] = possible_key_shifts(@encrypted_message[e_position - 1], date_shift(e_position, "e"))
    keys_by_letter[@n_position_shift] = possible_key_shifts(@encrypted_message[n_position - 1], date_shift(n_position, "n"))
    keys_by_letter[@d_position_shift] = possible_key_shifts(@encrypted_message[d_position - 1], date_shift(d_position, "d"))
    keys_by_letter
  end

  def potential_key_shifts
    final_potential_keys = Hash.new{|h,k| h[k] = []}
    #b key match
    a_b_matches = []
    b_c_matches = []
    key_shifts_by_letter[:b_second].each do |b_key|
      key_shifts_by_letter[:a_first].each do |a_key|
        a_b_matches << b_key if b_key[0] == a_key[1]
      end
      key_shifts_by_letter[:c_third].each do |c_key|
        b_c_matches << b_key if b_key[1] == c_key[0]
      end
    end
    final_potential_keys[:b_second] = a_b_matches.select do |key|
      b_c_matches.include?(key)
    end
    #a key match
    key_shifts_by_letter[:a_first].each do |a_key|
      final_potential_keys[:b_second].each do |b_key|
        final_potential_keys[:a_first] << a_key if a_key[1] == b_key[0]
      end
    end
    #c key match
    c_d_matches = []
    c_b_matches = []
    key_shifts_by_letter[:c_third].each do |c_key|
      key_shifts_by_letter[:d_fourth].each do |d_key|
        c_d_matches << c_key if d_key[0] == c_key[1]
      end
      final_potential_keys[:b_second].each do |b_key|
        c_b_matches << c_key if c_key[0] == b_key[1]
      end
    end
    final_potential_keys[:c_third] = c_d_matches.select do |key|
      c_b_matches.include?(key)
    end
    #d key matches
    key_shifts_by_letter[:d_fourth].each do |d_key|
      final_potential_keys[:c_third].each do |c_key|
        final_potential_keys[:d_fourth] << d_key if c_key[1] == d_key[0]
      end
    end
    final_potential_keys
  end

  def list_of_possible_keys
    final_potential_keys = potential_key_shifts
    keys = []
    if potential_key_shifts.all? {|k, shift| shift.length == 1}
      keys << final_potential_keys[:a_first][0] + final_potential_keys[:c_third][0] + final_potential_keys[:d_fourth][1]
    end
    keys
  end
end