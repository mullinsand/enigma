require 'enigma'

module KeyGenerator
  def generate_key
    number_array = ["0","1","2","3","4","5","6","7","8","9"]
    key = 5.times do
      key += number_array.rand
    end
  end
end