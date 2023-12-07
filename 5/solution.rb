require 'byebug'

file = File.open('5/input.txt')
lines = file.read.split("\n")

class ResourceMap
  def initialize(ranges)
    @ranges = ranges
  end

  def convert(resource)
    @ranges.each do |range|
      next_start, curr_start, range_length = range

      if resource >= curr_start && resource < curr_start + range_length
        return resource + (next_start - curr_start)
      end
    end

    resource
  end

  attr_accessor :ranges
end

def build_resource_maps(lines)
  ranges = []
  resource_maps = []

  (1...lines.length).each do |line_index|
    line = lines[line_index]

    next if line == ''

    if line.include?('map')
      if ranges.length > 0
        resource_maps << ResourceMap.new(ranges)
        ranges = []
      end

      next
    end

    ranges << line.split(' ').map(&:to_i)
  end

  resource_maps << ResourceMap.new(ranges) if ranges.length > 0

  resource_maps
end

seeds = lines[0].split(' ')[1..-1].map(&:to_i)
resource_maps = build_resource_maps(lines)
result = seeds.map do |seed|
  resource_maps.each do |map|
    seed = map.convert(seed)
  end
  seed
end.min

puts result

# # Part 2

def get_seed_ranges(lines)
  nums = lines[0].split(' ')[1..-1].map(&:to_i)
  seed_ranges = []
  i = 0
  while i < nums.size
    seed_ranges << (nums[i]..nums[i] + nums[i + 1] - 1)
    i += 2
  end

  seed_ranges
end

# The process
# Given a seed range and a list of sequential resource maps
# For each resource map:
# 1. Convert our range to N ranges. Add our original range, plus the converting factor, to a
#    `converted_ranges` variable. For each range in the resource map:
#     a.
# 2. For each N range
#    a) repeat "the process" for the remaining resource maps

# Converting a range:

def convert_range_to_resource(range, resource_map)
    converted = []

    resource_map.ranges.each do |next_resource_start, curr_resource_start, range_length|
      curr_resource_end = curr_resource_start + range_length - 1
      curr_range = (curr_resource_start..curr_resource_end)
      conversion_factor = next_resource_start - curr_resource_start

      if curr_resource_start > range.first && curr_resource_end < range.last
        converted << (range.first..curr_resource_start - 1)
        converted << (curr_resource_start + conversion_factor..curr_resource_end + conversion_factor)
        converted << (curr_resource_end + 1..range.last + 1)
      elsif range.cover?(curr_range.first) || curr_range.cover?(range.first)
        new_start = [range.first, curr_range.first].max
        new_end = [range.last, curr_range.last].min
        new_range = (new_start + conversion_factor..new_end + conversion_factor)

        converted << new_range
        if new_start > range.first
          converted << (range.first..new_range.first - 1)
        elsif new_end < range.last
          converted << (new_range.last + 1..range.last)
        end
      end
    end

    converted << range if converted.length == 0
    converted
end

def find_lowest_location(original_seed_range, resource_maps)
  resource_ranges = [original_seed_range]
  resource_maps.each do |resource_map|
    converted_ranges = []

    resource_ranges.each do |range|
      converted_ranges += convert_range_to_resource(range, resource_map)
    end

    resource_ranges = converted_ranges
  end

  resource_ranges.min_by { |r| r.first }.first
end

seed_ranges = get_seed_ranges(lines)
min_location = Float::INFINITY
seed_ranges.each do |seed_range|
  puts "Processing seed range: #{seed_range}"
  location = find_lowest_location(seed_range, resource_maps)

  min_location = location if location < min_location
end

puts min_location
