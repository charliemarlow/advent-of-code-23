require 'set'

file = File.open('3/input.txt')
lines = file.readlines.map(&:chomp)

def is_symbol?(char)
  char != '.' && !is_number?(char)
end

def is_number?(char)
  char.match?(/[0-9]/)
end

def find_adjacent_symbol(lines, row, col)
  lowest_row = row == 0 ? 0 : row - 1
  lowest_col = col == 0 ? 0 : col - 1
  highest_row = row == lines.length - 1 ? row : row + 1
  highest_col = col == lines[row].length - 1 ? col : col + 1

  (lowest_row..highest_row).each do |r|
    (lowest_col..highest_col).each do |c|
      next if r == row && c == col

      return true if is_symbol?(lines[r][c])
    end
  end

  false
end

row = 0
col = 0

found_numbers = []
(0...lines.length).each do |row|
  number = ''
  number_found = false

  (0...lines[row].length).each do |col|
    char = lines[row][col]
    if is_number?(char)
      number += char
      number_found ||= find_adjacent_symbol(lines, row, col)
    else
      found_numbers << number.to_i if number_found

      number = ''
      number_found = false
    end
  end

  found_numbers << number.to_i if number_found
end

puts found_numbers.sum

# Part 2

def nearby_gear(lines, row, col)
  lowest_row = row == 0 ? 0 : row - 1
  lowest_col = col == 0 ? 0 : col - 1
  highest_row = row == lines.length - 1 ? row : row + 1
  highest_col = col == lines[row].length - 1 ? col : col + 1

  (lowest_row..highest_row).each do |r|
    (lowest_col..highest_col).each do |c|
      next if r == row && c == col

      return [r, c] if lines[r][c] == '*'
    end
  end

  nil
end

row = 0
col = 0
nums_by_gear_location = Hash.new { |h, k| h[k] = [] }

(0...lines.length).each do |row|
  number = ''
  gear_loc = nil

  (0...lines[row].length).each do |col|
    char = lines[row][col]
    if is_number?(char)
      number += char
      gear_loc ||= nearby_gear(lines, row, col)
    elsif number
      nums_by_gear_location[gear_loc] << number.to_i if gear_loc

      number = ''
      gear_loc = nil
    end
  end

  nums_by_gear_location[gear_loc] << number.to_i if gear_loc
end

sum = 0
nums_by_gear_location.each do |gear, nums|
  next unless nums.size == 2

  ratio = nums.inject(&:*)
  sum += ratio
end

puts sum
