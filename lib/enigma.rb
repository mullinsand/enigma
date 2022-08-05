class Enigma
  attr_reader
  def initialize
    #component_creation
    #CLI Class
    #run CLI method
      #Input (encryption, decryption, crack)
      #Sends info onto crypto class
      #Outputs final stuff
    #Enigma Class
  end

  def encrypt(message, given_key, given_date)
    {
      encryption: encrypt_message(message, given_key, given_date),
      key: given_key,
      date: given_date
    }
  end
end