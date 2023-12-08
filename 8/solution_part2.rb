file = File.open('8/input.txt')
lines = file.readlines.map(&:chomp).reject(&:empty?)

instructions = lines[0]
nodes = lines[1..-1]

curr_nodes = []
graph = nodes.to_h do |node|
  node, children = node.split(' = ')
  left, right = children.gsub(/[()]/, '').split(', ')

  curr_nodes << node if node[-1] == 'A'

  [node, [left, right]]
end

i = 0
steps = 0
steps_to_z = []
while true
  steps += 1
  instruction = instructions[i]

  curr_nodes = curr_nodes.map do |curr|
    if instruction == 'L'
      curr = graph[curr][0]
    else
      curr = graph[curr][1]
    end

    if curr[-1] == 'Z'
      steps_to_z << steps
      nil
    else
      curr
    end
  end.compact

  break if curr_nodes.empty?

  if i == instructions.size - 1
    i = 0
  else
    i += 1
  end
end

puts steps_to_z.reduce(1, :lcm)
