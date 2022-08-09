require './lib/enigma'

filename = ARGV[1]
input = File.open(ARGV[0], "r")
output = File.open(ARGV[1], "w")
key = ARGV[2]
date = ARGV[3]
message = input.read.downcase
enigma = Enigma.new
secrets = enigma.encrypt(message, key, date)
output.write(secrets[:encryption])
output.close
puts "Created '#{filename}' with the key #{secrets[:key]} and date #{secrets[:date]}"