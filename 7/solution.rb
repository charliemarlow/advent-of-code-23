# Idea: custom sort function for hands
# def score_hand looks at frequency of the cards and returns an integer value repping
# it's score
# def score_card computes a numerical score for the card type

# Custom sort
# if score_a != score_b, score_a <=> score_b
# else 5.times { |i| card_score(a) != card_score_b, early ret }

# Once it's sorted, each with_index and sum it up + 1

file = File.open('7/input.txt')
lines = file.readlines

SCORE_BY_CARD = {
  'A' => 13,
  'K' => 12,
  'Q' => 11,
  'J' => 0,
  'T' => 9,
  '9' => 8,
  '8' => 7,
  '7' => 6,
  '6' => 5,
  '5' => 4,
  '4' => 3,
  '3' => 2,
  '2' => 1,
}

def frequency(str)
  freq = Hash.new(0)

  str.each_char do |c|
    freq[c] += 1
  end

  freq
end

def score_hand(hand)
  freq = frequency(hand)

  jokers = freq['J']
  freq.delete('J')

  max_key = freq.keys.max_by { |k| freq[k] }
  freq[max_key] += jokers

  freq.values.max - freq.values.size
end

bids_by_card = {}
lines.each do |line|
  card, bid = line.split(' ')

  bids_by_card[card] = bid.to_i
end

cards = bids_by_card.keys
sorted = cards.sort do |a, b|
  a_score = score_hand(a)
  b_score = score_hand(b)

  if a_score != b_score
    a_score <=> b_score
  else
    5.times do |i|
      a_score = SCORE_BY_CARD[a[i]]
      b_score = SCORE_BY_CARD[b[i]]

      if a_score != b_score
        break a_score <=> b_score
      end
    end
  end
end

result = 0
sorted.each_with_index do |card, index|
  bid = bids_by_card[card]
  result += bid * (index + 1)
end

puts result
