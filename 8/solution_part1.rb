file = File.open('8/input.txt')
lines = file.readlines.map(&:chomp).reject(&:empty?)

instructions = lines[0]
nodes = lines[1..-1]

graph = nodes.to_h do |node|
  node, children = node.split(' = ')
  left, right = children.gsub(/[()]/, '').split(', ')

  [node, [left, right]]
end

i = 0
steps = 0
curr = 'AAA'
while true
  steps += 1
  instruction = instructions[i]

  if instruction == 'L'
    curr = graph[curr][0]
  else
    curr = graph[curr][1]
  end

  break if curr == 'ZZZ'

  if i == instructions.size - 1
    i = 0
  else
    i += 1
  end
end

puts steps
