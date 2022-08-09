require './lib/shiftable'
require './lib/positionator'
require './lib/key_crack'
require './lib/key_generator'

class Enigma
  include KeyGenerator
  include Shiftable
  include Positionator
  include KeyCrack
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