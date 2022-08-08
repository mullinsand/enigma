require './lib/enigma'
require './lib/key_generator'

filename = ARGV[1]
input = File.open(ARGV[0], "r")
output = File.open(ARGV[1], "w")
date = ARGV[2]
ciphertext = input.read
enigma = Enigma.new
decrypted = enigma.crack(ciphertext, date)
output.write(decrypted[:decryption])
output.close
puts "Created '#{filename}' with the cracked key #{decrypted[:key]} and date #{decrypted[:date]}"
if enigma.list_of_possible_keys.length > 1
  puts "Other possible keys were #{enigma.list_of_possible_keys[1..enigma.list_of_possible_keys.length].join(', ')}."
end