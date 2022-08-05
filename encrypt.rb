require './lib/enigma'
require './lib/key_generator'


if ARGV.length != 2
  puts "Two arguments please"
  exit
end
filename = ARGV[1]
input = File.open(ARGV[0], "r")
output = File.open(ARGV[1], "w")
puts "Use date other than today's - Date must be in the format MMDDYY"
date = gets.chomp

message = input.read
enigma = Enigma.new
secrets = enigma.encrypt(message, enigma.generate_key)
ciphertext = secrets[:encryption]
output.write(ciphertext)
output.close
puts "Created '#{filename} with the key #{secrets[:key]} and date #{secrets[:date]}"
