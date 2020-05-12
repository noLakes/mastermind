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

  def Pin.build(num)
    @container = {}
    num.times {|num| @container[num + 1] = self.new(' ')}
    return @container
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

  attr_reader :pins, :clues
  def initialize(pins=4, clues=4)
    @pins = {}.merge!(Pin.build(pins))
    @clues = {}.merge!(Clue.build(clues))
  end

  def pin_val(pin, val)
    @pins[pin].set_val = val
  end

  def txt
    #build the text used to show the row in command line window!
  end
end

class Board
  def initialize

  end

end


# testing area below!!!!

# [   ][   ][   ][   ] --------- [ ][ ][ ][ ]

x = Row.new(4, 4)
x.pin_val(1, 'W')
p x.pins[1].txt
