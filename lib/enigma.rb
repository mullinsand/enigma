class Enigma
  attr_accessor :message,
              :given_key,
              :given_date

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

  end
end