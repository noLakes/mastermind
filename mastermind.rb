DEFAULT_CELL = ['[', ' ', ' ', ' ', ']']

class Cell
  attr_reader :full, :val
  
  def initialize(val=' ')
    @val = val
    @full = ['[', ' ', "#{@val}", ' ', ']'].join('')
  end

  def newVal(val)
    @val = val
    @full = ['[', ' ', "#{@val}", ' ', ']'].join('')
  end

  def clearVal
    @val = ' '
  end

end

class Row
  attr_reader :full, :cells
  # figure out the best way to construct a row object
  # change name of 'cell' to pin - its representing the colored pins afterall
  # include cell printing characters in Row or Board area
  def initialize(cell1=Cell.new, cell2=Cell.new, cell3=Cell.new, cell4=Cell.new)
    @cells = {1 => cell1.full, 2 => cell2.full, 3 => cell3.full, 4 => cell4.full}
    @full = @cells.values.flatten.join

  end
end

class Board
  def initialize

  end

end


# [   ][   ][   ][   ] --------- [ ][ ][ ][ ]

x = Cell.new('X')
puts x.full
x.newVal('J')
puts x.full
row = Row.new
puts row.full
