# Part 1
def calibration_value(line)
  result = ''
  prev_digit = ''

  line.each_char do |char|
    next unless char.match?(/[0-9]/)

    result += char if result.size == 0
    prev_digit = char
  end

  (result + prev_digit).to_i
end

file = File.open('1/input.txt')
lines = file.readlines.map(&:chomp)
sum = lines.sum { |line| calibration_value(line) }

# Part 2
# Idea, create a trie of all of the numbers spelled out.
# Iterate through each line, if there's a trie match, use that num.
# Otherwise, next character.

class Node
  def initialize(value)
    @value = value
    @children = {}
  end

  def add_child(child_value)
    @children[child_value] = Node.new(child_value)
  end

  def matches_next_char?(char)
    @children[char] != nil
  end

  def leaf?
    @children.size == 0
  end

  attr_accessor :children
end

def build_trie(words)
  root = Node.new('')

  words.each do |word|
    current_node = root
    word.each_char do |char|
      current_node.add_child(char) unless current_node.children[char]
      current_node = current_node.children[char]
    end
  end

  root
end

WORD_TO_NUMERIC = {
  'one' => '1',
  'two' => '2',
  'three' => '3',
  'four' => '4',
  'five' => '5',
  'six' => '6',
  'seven' => '7',
  'eight' => '8',
  'nine' => '9',
}

def find_word(line, start, trie)
  spelled_number = ''

  while start < line.size && trie.matches_next_char?(line[start])
    trie_char = line[start]
    spelled_number += trie_char
    trie = trie.children[trie_char]
    start += 1

    next unless trie.leaf?

    return spelled_number
  end

  nil
end

def track_number(num, result)
  if result.size == 0
    result = [num, num]
  else
    result[1] = num
  end

  result
end

def calibration_value(line, trie)
  result = []
  prev_digit = ''

  index = 0
  while index < line.size
    char = line[index]

    if char.match?(/[0-9]/)
      result = track_number(char, result)
    else
      word = find_word(line, index, trie)
      result = track_number(WORD_TO_NUMERIC[word], result) if word
    end

    index += 1
  end

  result.join('').to_i
end

file = File.open('1/input.txt')
lines = file.readlines.map(&:chomp)
trie = build_trie(WORD_TO_NUMERIC.keys)
sum = lines.sum { |line| calibration_value(line, trie) }

puts sum
