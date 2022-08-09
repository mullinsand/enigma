require 'enigma'

class KeyCrack < Enigma
  attr_reader
  def initialize
    # A value of 1 is an A shift, 2 is a B shift, 3 C shift, and 4 D shift
    super
    require 'pry'; binding.pry
    @space_key_shift = space_position % 4
    @e_key_shift = e_position % 4
    @n_key_shift = n_position % 4
    @d_key_shift = d_position % 4
  end

end