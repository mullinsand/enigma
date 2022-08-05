require './lib/enigma'
require './lib/key_generator'

filename = ARGV[1]
input = File.open(ARGV[0], "r")
output = File.open(ARGV[1], "w")
date = ARGV[2] if ARGV[2]
message = input.read.downcase
enigma = Enigma.new
secrets = enigma.encrypt(message, enigma.generate_key)
ciphertext = secrets[:encryption]
output.write(ciphertext)
output.close
puts "Created '#{filename}' with the key #{secrets[:key]} and date #{secrets[:date]}"
