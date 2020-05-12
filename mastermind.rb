DEFAULT_CELL = ['[', ' ', ' ', ' ', ']']

class Pin
  attr_reader :val, :txt

  @@COLORS = ['R', 'G', 'B', 'W', 'Y', 'O']
  
  def initialize(color=@@COLORS.sample)
    @val = color
  end

  def Pin.blank 
    pin = Pin.new
    pin.set_val = ' '
    return pin
  end

  def txt
    return ['[', ' ', "#{@val}", ' ', ']'].join('')
  end

  def set_val=(color)
    @val = color
  end

  def clear_val
    @val = ' '
  end

end

class Clue < Pin
  @@COLORS = ['X', 'O']

  def initialize(color=' ')
    @val = color
  end

  def txt
    return ['[', "#{@val}", ']'].join('')
  end
end

class Row
  # figure out the best way to construct a row object
  # change name of 'cell' to pin - its representing the colored pins afterall
  # include cell printing characters in Row or Board area
  def initialize
    @pins = {}
    @clues = {}
  end
end

class Board
  def initialize

  end

end


# [   ][   ][   ][   ] --------- [ ][ ][ ][ ]

myPins = {}
10.times do |x|
  myPins[x+1] = Pin.new
end

myPins.each_value {|key| puts key.txt}

