mkdir "$1"
touch "$1/solution_part1.rb"
touch "$1/solution_part2.rb"
touch "$1/input.txt"
touch "$1/test.txt"

echo "file = File.open('$1/test.txt')\n" > "$1/solution_part1.rb"
echo "file = File.open('$1/test.txt')\n" > "$1/solution_part2.rb"
