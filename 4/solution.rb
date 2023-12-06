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

# Part 2
def score(winning, having)
  winning = Set.new(winning)

  result = 0
  having.each do |num|
    result += 1 if winning.include?(num)
  end

  result
end

cards_by_num = Hash.new(0)
max_card_num = lines.length

sum = lines.sum do |line|
  card, numbers = line.split(':')

  card_num = card.split(' ')[1].to_i
  cards_by_num[card_num] += 1

  winning, having = numbers.split('|').map do |nums|
    nums.split(' ').map(&:to_i)
  end
  points = score(winning, having)

  upper_limit = [max_card_num, card_num + points].min
  (card_num + 1..upper_limit).each do |i|
    cards_by_num[i] += cards_by_num[card_num]
  end

  cards_by_num[card_num]
end

puts sum
