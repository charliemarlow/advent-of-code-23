require 'byebug'

file = File.open('6/input.txt')
lines = file.readlines

times, distances = lines.map do |line|
  line.split(':')[1].split(' ').map(&:to_i)
end

raise 'bad data' if times.size != distances.size

def ways_to_win(time, distance)
  counter = 0
  0.upto(time) do |hold_time|
    go_time = time - hold_time
    go_dist = hold_time * go_time

    counter += 1 if go_dist > distance
  end

  counter
end

result = 1
0.upto(times.size - 1) do |i|
  result *= ways_to_win(times[i], distances[i])
end

puts result

# Part 2
file = File.open('6/input.txt')
lines = file.readlines

time, distance = lines.map do |line|
  line.split(':')[1].split(' ').join('').to_i
end

ways_to_win(time, distance)
