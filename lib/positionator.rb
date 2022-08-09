module Positionator
  def space_position
    @encrypted_message.length - 3
  end

  def e_position
    @encrypted_message.length - 2
  end

  def n_position
    @encrypted_message.length - 1
  end

  def d_position
    @encrypted_message.length
  end

  def a_position?(position)
    position % 4 == 1
  end

  def b_position?(position)
    position % 4 == 2
  end

  def c_position?(position)
    position % 4 == 3
  end

  def d_position?(position)
    position % 4 == 0
  end

  def character_index(character)
    @character_set.index(character)
  end

  def decrypted_end
    " end".split("")
  end

  def encrypted_end
    @encrypted_message[-4..].split("")
  end

  def shift_type_end
    [space_position % 4, e_position % 4, n_position % 4, d_position % 4]
  end

  def convert_to_index(array)
    array.map {|letter| character_index(letter)}
  end

  def convert_to_negative_index(array)
    array.map {|letter| -character_index(letter)}
  end

  def convert_to_negative_date_shift(array)
    array.map do |shift_type|
      if a_position?(shift_type)
        -a_date_shift
      elsif b_position?(shift_type)
        -b_date_shift
      elsif c_position?(shift_type)
        -c_date_shift
      elsif d_position?(shift_type)
        -d_date_shift
      end
    end
  end

  def rotate_to_abcd_order(array)
    times_to_rotate = 0
    abcd_array = shift_type_end
    until abcd_array[0] == 1
      abcd_array.rotate!
      times_to_rotate += 1
    end
    times_to_rotate.times do
      array.rotate!
    end
    array
  end
end