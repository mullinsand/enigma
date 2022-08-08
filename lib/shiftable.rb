module Shiftable
  def square_date
    @given_date.to_i**2
  end

  def a_key_shift
    @given_key[0..1].to_i
  end

  def b_key_shift
    @given_key[1..2].to_i
  end

  def c_key_shift
    @given_key[2..3].to_i
  end

  def d_key_shift
    @given_key[3..4].to_i
  end

  def a_date_shift
    square_date.digits[3]
  end

  def b_date_shift
    square_date.digits[2]
  end

  def c_date_shift
    square_date.digits[1]
  end

  def d_date_shift
    square_date.digits[0]
  end

  def a_final_shift
    a_key_shift + a_date_shift
  end

  def b_final_shift
    b_key_shift + b_date_shift
  end

  def c_final_shift
    c_key_shift + c_date_shift
  end

  def d_final_shift
    d_key_shift + d_date_shift
  end

  def a_shift(character)
    @character_set[(@character_set.index(character) + a_final_shift) % 27]
  end

  def b_shift(character)
    @character_set[(@character_set.index(character) + b_final_shift) % 27]
  end

  def c_shift(character)
    @character_set[(@character_set.index(character) + c_final_shift) % 27]
  end

  def d_shift(character)
    @character_set[(@character_set.index(character) + d_final_shift) % 27]
  end

  def reverse_a_shift(character)
    @character_set[(@character_set.index(character) - a_final_shift) % 27]
  end

  def reverse_b_shift(character)
    @character_set[(@character_set.index(character) - b_final_shift) % 27]
  end

  def reverse_c_shift(character)
    @character_set[(@character_set.index(character) - c_final_shift) % 27]
  end

  def reverse_d_shift(character)
    @character_set[(@character_set.index(character) - d_final_shift) % 27]
  end
end