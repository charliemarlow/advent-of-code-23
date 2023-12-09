file = File.open('9/input.txt')

histories = file.readlines.map do |line|
  line.split(' ').map(&:to_i)
end

def differences(arr)
  result = []
  0.upto(arr.size - 2) do |i|
    result << arr[i + 1] - arr[i]
  end

  result
end

result = histories.sum do |history|
  stack = []
  while history.uniq.size > 1
    stack.push(history.first)
    history = differences(history)
  end

  nxt = stack.pop - history.first
  while !stack.empty?
    nxt = stack.pop - nxt
  end

  nxt
end

puts result
