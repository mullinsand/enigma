require './lib/enigma'

filename = ARGV[1]
input = File.open(ARGV[0], "r")
output = File.open(ARGV[1], "w")
key = ARGV[2]
date = ARGV[3]
ciphertext = input.read
enigma = Enigma.new
decrypted = enigma.decrypt(ciphertext, key, date)
output.write(decrypted[:decryption])
output.close
puts "Created '#{filename}' with the key #{decrypted[:key]} and date #{decrypted[:date]}"
