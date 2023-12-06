
file = File.open('2/input.txt')
lines = file.readlines.map(&:chomp)

# Part 1
COLOR_TO_MAX = {
  'red' => 12,
  'green' => 13,
  'blue' => 14,
}

def possible?(actions)
  actions.split(';').each do |show|
    num_and_color = show.split(',').map { |entry| entry.split(' ') }

    num_and_color.each do |num, color|
      puts "color: #{color}, num: #{num}"
      return false if num.to_i > COLOR_TO_MAX[color]
    end
  end
end


sum = lines.sum do |line|
  game, actions = line.split(':')

  game_id = game.split(' ')[1].to_i

  possible?(actions) ? game_id : 0
end

puts sum

# Part 2

def power(actions)
  max_value_by_color = {
    'red' => 0,
    'green' => 0,
    'blue' => 0,
  }

  actions.split(';').each do |show|
    num_and_color = show.split(',').map { |entry| entry.split(' ') }

    num_and_color.each do |num, color|
      max_value_by_color[color] = [max_value_by_color[color], num.to_i].max
    end
  end

  max_value_by_color.values.inject(:*)
end

sum = lines.sum do |line|
  game, actions = line.split(':')

  power(actions)
end

puts sum
