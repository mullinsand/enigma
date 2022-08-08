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
end