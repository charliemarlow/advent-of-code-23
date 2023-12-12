file = File.open('10/input.txt')

map = file.readlines

class Pipe
  def initialize(curr:, prev:, map:)
    @curr = curr
    @prev = prev
    @map = map
  end

  attr_accessor :curr
  attr_accessor :prev

  def next
    new_curr = (options - [prev]).first

    Pipe.new(
      curr: new_curr,
      prev: curr,
      map: @map,
    )
  end

  private

  def options
    pipe = @map[curr.first][curr.last]

    case pipe
    when '|'
      [
        [curr.first - 1, curr.last],
        [curr.first + 1, curr.last],
      ]
    when '-'
      [
        [curr.first, curr.last - 1],
        [curr.first, curr.last + 1],
      ]
    when 'L'
      [
        [curr.first - 1, curr.last],
        [curr.first, curr.last + 1],
      ]
    when 'J'
      [
        [curr.first - 1, curr.last],
        [curr.first, curr.last - 1],
      ]
    when '7'
      [
        [curr.first, curr.last - 1],
        [curr.first + 1, curr.last],
      ]
    when 'F'
      [
        [curr.first, curr.last + 1],
        [curr.first + 1, curr.last],
      ]
    else
      raise 'invalid loop'
    end
  end
end

start = []
row = 0
map.each do |line|
  col = 0
  line.each_char do |char|
    if char == 'S'
      start = [row, col]
    end

    col += 1
  end

  break if !start.empty?

  row += 1
end

# There's no ambiguity about S's type in my input,
# so hardcode for now
a = Pipe.new(
  curr: [start.first - 1, start.last],
  prev: start,
  map: map,
)
b = Pipe.new(
  curr: [start.first + 1, start.last],
  prev: start,
  map: map,
)

steps = 1
while a.curr != b.curr
  a = a.next
  b = b.next
  steps += 1
end

puts "#{steps}"
