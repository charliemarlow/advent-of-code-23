require 'set'

file = File.open('4/input.txt')
lines = file.readlines.map(&:chomp)

# Part 1

def score(winning, having)
  winning = Set.new(winning)

  result = 0

  having.each do |num|
    next unless winning.include?(num)

    if result == 0
      result = 1
      next
    end

    result *= 2
  end

  result
end

sum = lines.sum do |line|
  numbers = line.split(':')[1]
  winning, having = numbers.split('|').map do |nums|
    nums.split(' ').map(&:to_i)
  end

  score(winning, having)
end

puts sum
