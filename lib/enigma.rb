require 'key_generator'
require 'shiftable'
require 'positionator'

class Enigma
  include KeyGenerator
  include Shiftable
  include Positionator
  attr_accessor :message,
              :given_key,
              :given_date,
              :character_set,
              :encrypted_message

  def initialize
    @character_set = ["a", "b", "c", "d", "e", "f", 
                      "g", "h", "i", "j", "k", "l", 
                      "m", "n", "o", "p", "q", "r", 
                      "s", "t", "u", "v", "w", "x", 
                      "y", "z", " "]
  end

  def encrypt(message, given_key, given_date)
    @message = message
    given_key ||= generate_key
    @given_key = given_key
    given_date ||= Time.new.strftime("%d%m%y")
    @given_date = given_date
    {
      encryption: encrypt_message,
      key: @given_key,
      date: @given_date
    }
  end

  def decrypt(ciphertext, given_key, given_date)
    @encrypted_message = ciphertext
    @given_key = given_key
    given_date ||= Time.new.strftime("%d%m%y")
    @given_date = given_date
    {
      decryption: decrypt_message,
      key: @given_key,
      date: @given_date
    }
  end

  def encrypt_message
    position = 0
    @encrypted_message = @message.split("").map do |character|
      position += 1
      if !@character_set.include?(character)
        character
      elsif a_position?(position)
        a_shift(character)
      elsif b_position?(position)
        b_shift(character)
      elsif c_position?(position)
        c_shift(character)
      elsif d_position?(position)
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
      elsif a_position?(position)
        reverse_a_shift(character)
      elsif b_position?(position)
        reverse_b_shift(character)
      elsif c_position?(position)
        reverse_c_shift(character)
      elsif d_position?(position)
        reverse_d_shift(character)
      end
    end.join
  end

  def decrypted_end
    " end".split("")
  end

  def encrypted_end
    @encrypted_message[-4..].split("")
  end

  def shift_type_end
    [space_position % 4, e_position % 4, n_position % 4, d_position % 4]
  end

  def convert_to_index(array)
    array.map {|letter| character_index(letter)}
  end

  def convert_to_negative_index(array)
    array.map {|letter| -character_index(letter)}
  end

  def convert_to_negative_date_shift(array)
    array.map do |shift_type|
      if a_position?(shift_type)
        -a_date_shift
      elsif b_position?(shift_type)
        -b_date_shift
      elsif c_position?(shift_type)
        -c_date_shift
      elsif d_position?(shift_type)
        -d_date_shift
      end
    end
  end

  def absolute_key_shift
    index_encrypted_end = convert_to_index(encrypted_end)
    neg_index_decrypted_end = convert_to_negative_index(decrypted_end)
    neg_date_shift_end = convert_to_negative_date_shift(shift_type_end)
    raw_key_shift = index_encrypted_end.zip(neg_index_decrypted_end, neg_date_shift_end).map(&:sum)
    raw_key_shift.map {|key| key.negative? ? key += 27 : key}
  end

  def convert_key_to_string(key_integer)
    key_integer.to_s.length == 1 ? "0#{key_integer.to_s}" : key_integer.to_s
  end

  def rotate_to_abcd_order(array)
    times_to_rotate = 0
    abcd_array = shift_type_end
    until abcd_array[0] == 1
      abcd_array.rotate!
      times_to_rotate += 1
    end
    times_to_rotate.times do
      array.rotate!
    end
    array
  end

  # def order_format_keys(array)
  #   formatted_keys = array.map do |key|
  #     convert_key_to_string(key)
  #   end
  #   rotate_to_abcd_order(formatted_keys)
  # end

  def all_possible_key_shifts
    all_possible_keys = absolute_key_shift.map do |key|
      all_key_shifts = []
      all_key_shifts << key_shift = key
      until key_shift > 100
        key_shift += 27
        all_key_shifts << key_shift if key_shift < 100
      end
      all_key_shifts.map {|key| convert_key_to_string(key)}
    end
    rotate_to_abcd_order(all_possible_keys)
  end
  # def encrypt_character_by_position(position)
  #   @encrypted_message[position - 1]
  # end

  # def decrypt_character_by_position(position)
  #   return if position < (@encrypted_message.length - 3)
  #   @encrypted_message[position - 1]
  # end

  def key_shift(position, encrypted_character, decrypted_character)
    key_shift = []
    
    if a_position?(position)
      key_shift << :alpha
      key_shift << character_index(encrypted_character) - character_index(decrypted_character) + a_date_shift
    elsif b_position?(position)
      key_shift << :beta
      key_shift << character_index(encrypted_character) - character_index(decrypted_character) + b_date_shift
    elsif c_position?(position)
      key_shift << :gamma
      key_shift << character_index(encrypted_character) - character_index(decrypted_character) + c_date_shift
    elsif d_position?(position)
      key_shift << :delta
      key_shift << character_index(encrypted_character) - character_index(decrypted_character) + a_date_shift
    end
    key_shift
  end

  def list_of_key_shifts
    key_shifts = Hash.new
    position = 0
    @encrypted_message.split.each do |letter|
      position += 1
      return if position < (@encrypted_message.length - 3)
      key_shift

    end
  end

  def date_shift(position, character)
    #based on position, it determines the type of date shift (ABCD), applies the shift,
    #and then spits out the character that it ends up on
    if a_position?(position)
      @character_set[(character_index(character) + a_date_shift) % 27]
    elsif b_position?(position)
      @character_set[(character_index(character) + b_date_shift) % 27]
    elsif c_position?(position)
      @character_set[(character_index(character) + c_date_shift) % 27]
    elsif d_position?(position)
      @character_set[(character_index(character) + d_date_shift) % 27]
    end
  end

  def possible_key_shifts(encrypted_character, date_shifted_character)
    raw_key_shift = character_index(encrypted_character) - character_index(date_shifted_character)
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
      keys << final_potential_keys[:a_first][0] + final_potential_keys[:c_third][0] + final_potential_keys[:d_fourth][0][1]
    else
      keys = multiple_keys_scenario
    end
    keys
  end

  def multiple_keys_scenario
    final_potential_keys = potential_key_shifts
    keys = []
    final_potential_keys[:a_first].each do |a_key|
      final_potential_keys[:b_second].each do |b_key|
        final_potential_keys[:c_third].each do |c_key|
          final_potential_keys[:d_fourth].each do |d_key|
            keys << a_key + c_key + d_key[1] if valid_key?(a_key, b_key, c_key, d_key)
          end
        end
      end
    end
    keys
  end

  def valid_key?(a_key, b_key, c_key, d_key)
    a_key[1] == b_key[0] &&
      b_key[1] == c_key[0] &&
      c_key[1] == d_key[0]
  end

  def assign_all_letter_shift
    assign_letter_shift(space_position)
    assign_letter_shift(e_position)
    assign_letter_shift(n_position)
    assign_letter_shift(d_position)
  end

  def crack(ciphertext, given_date)
    @encrypted_message = ciphertext
    assign_all_letter_shift
    given_date ||= Time.new.strftime("%d%m%y")
    @given_date = given_date
    @given_key = list_of_possible_keys[0]
    {
      decryption: decrypt_message,
      key: list_of_possible_keys[0],
      date: given_date
    }
  end
end