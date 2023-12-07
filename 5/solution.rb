require 'byebug'

file = File.open('5/input.txt')
lines = file.readlines

seeds = lines[0].split(':')[1].split(' ').map(&:to_i)

maps = []
resource_maps = []
lines[1..-1].each do |line|
  if line == "\n" || line.match?(/map/)
    maps << resource_maps if resource_maps.size > 0
    resource_maps = []

    next
  end

  resource_maps << line.split(' ').map(&:to_i)
end
maps << resource_maps if resource_maps.size > 0

def convert(resource, ranges)
  ranges.each do |nxt, curr, length|
    if resource >= curr && resource < curr + length
      return resource + nxt - curr
    end
  end

  resource
end

min = Float::INFINITY
seeds.each do |seed|
  maps.each { |ranges| seed = convert(seed, ranges) }
  min = seed if seed < min
end

puts min
