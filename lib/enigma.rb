class Enigma
  attr_accessor :message,
              :given_key,
              :given_date,
              :character_set

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
    @character_set = ["a", "b", "c", "d", "e", "f", 
                      "g", "h", "i", "j", "k", "l", 
                      "m", "n", "o", "p", "q", "r", 
                      "s", "t", "u", "v", "w", "x", 
                      "y", "z", " "]
  end

  def encrypt(message, given_key, given_date = Time.new.strftime("%m%d%y"))
    @message = message
    @given_key = given_key
    @given_date = given_date
    {
      encryption: encrypt_message(message, given_key, given_date),
      key: given_key,
      date: given_date
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
   
  def encrypt_message
    position = 1
    decrypted_message = []
    @message.split("").each do |character|
      if position % 4 == 1
        decrypted_message << a_shift(character)
      elsif position % 4 == 2 
        decrypted_message << b_shift(character)
      elsif position % 4 == 3
        decrypted_message << c_shift(character)
      elsif position % 4 == 0
        decrypted_message << d_shift(character) 
      end
      position += 1
    end
    decrypted_message.join
  end
end