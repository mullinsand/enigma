require './lib/enigma'

module KeyGenerator
  def generate_key
    number_array = ["0","1","2","3","4","5","6","7","8","9"]
    key_picks = []
    5.times do
      key_picks << number_array.sample
    end
    key_picks.join
  end
end