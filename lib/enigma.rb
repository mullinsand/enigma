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

  def keys_by_shift
    [:alpha, :beta, :gamma, :delta].zip(all_possible_key_shifts).to_h
  end

  def beta_matched_keys
    matches = Hash.new{|h,k| h[k] = []}
    keys_by_shift[:beta].each do |beta_key|
      keys_by_shift[:alpha].each do |alpha_key|
        matches[:a_b] << beta_key if beta_key[0] == alpha_key[1]
      end
      keys_by_shift[:gamma].each do |gamma_key|
        matches[:b_c] << beta_key if beta_key[1] == gamma_key[0]
      end
    end
    matches[:a_b].select { |key| matches[:b_c].include?(key) }
  end

  def gamma_matched_keys(matched_keys)
    matches = Hash.new{|h,k| h[k] = []}
    keys_by_shift[:gamma].each do |gamma_key|
      keys_by_shift[:delta].each do |delta_key|
        matches[:c_d] << gamma_key if delta_key[0] == gamma_key[1]
      end
      matched_keys[:beta].each do |beta_key|
        matches[:c_b] << gamma_key if beta_key[1] == gamma_key[0]
      end
    end
    matches[:c_d].select { |key| matches[:c_b].include?(key) }
  end

  def alpha_matched_keys(matched_keys)
    matches = []
    keys_by_shift[:alpha].each do |alpha_key|
      matched_keys[:beta].each do |beta_key|
        matches << alpha_key if alpha_key[1] == beta_key[0]
      end
    end
    matches
  end

  def delta_matched_keys(matched_keys)
    matches = []
    keys_by_shift[:delta].each do |delta_key|
      matched_keys[:gamma].each do |gamma_key|
        matches << delta_key if gamma_key[1] == delta_key[0]
      end
    end
    matches
  end


  def all_matched_key_shifts
    matched_keys = Hash.new{|h,k| h[k] = []}
    #b key match
    matched_keys[:beta] = beta_matched_keys
    #a key match
    matched_keys[:alpha] = alpha_matched_keys(matched_keys)
    #c key match
    matched_keys[:gamma] = gamma_matched_keys(matched_keys)
    #d key matches
    matched_keys[:delta] = delta_matched_keys(matched_keys)
    matched_keys
  end

  def list_of_possible_keys
    keys_hash = all_matched_key_shifts
    keys = []
    if all_matched_key_shifts.all? {|shift_type, matched_keys| matched_keys.length == 1}
      keys << combined_key(keys_hash[:alpha][0], keys_hash[:gamma][0], keys_hash[:delta][0])
    else
      keys = multiple_keys_scenario(keys_hash)
    end
    keys
  end

  def combined_key(alpha_key, gamma_key, delta_key)
    alpha_key + gamma_key + delta_key[1]
  end

  def multiple_keys_scenario(keys_hash)
    keys = []
    keys_hash[:alpha].each do |alpha_key|
      keys_hash[:beta].each do |beta_key|
        keys_hash[:gamma].each do |gamma_key|
          keys_hash[:delta].each do |delta_key|
            if valid_key?(alpha_key, beta_key, gamma_key, delta_key)
              keys << combined_key(alpha_key, gamma_key, delta_key)
            end
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

  def crack(ciphertext, given_date)
    @encrypted_message = ciphertext
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