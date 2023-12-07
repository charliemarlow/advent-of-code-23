require 'byebug'

file = File.open('5/input.txt')
lines = file.readlines

seeds = lines[0].split(':')[1].split(' ').map(&:to_i)
seed_ranges = []
i = 0

while i < seeds.size do
  range = (seeds[i]..seeds[i] + seeds[i + 1] - 1)
  seed_ranges << range
  i += 2
end

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

def overlaps?(r1, r2)
  r1.cover?(r2.first) || r2.cover?(r1.first)
end

def convert(sources, maps)
  converted = []

  maps.each do |nxt, start, length|
    map_range = (start..start + length - 1)
    factor = nxt - start

    new_sources = []
    sources.each do |source_range|
      unless overlaps?(source_range, map_range)
        new_sources << source_range
        next
      end

      if map_range.first <= source_range.first
        new_start = source_range.first
      else
        new_start = map_range.first
        new_sources << (source_range.first..new_start - 1)
      end

      if map_range.last >= source_range.last
        new_last = source_range.last
      else
        new_last = map_range.last
        new_sources << (new_last + 1..source_range.last)
      end

      converted << (new_start + factor..new_last + factor)
    end

    sources = new_sources
  end

  converted + sources
end

min = Float::INFINITY
seed_ranges.each do |seed_range|
  potential_ranges = [seed_range]
  maps.each do |map_ranges|
    potential_ranges = convert(potential_ranges, map_ranges)
  end

  min_location = potential_ranges.min_by(&:first).first
  min = min_location if min_location < min
end

puts min
