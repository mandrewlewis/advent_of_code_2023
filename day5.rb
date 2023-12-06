# frozen_string_literal: true

require './inputs/day5_input'
include Day5Input

# AoC Day5
class Day5
  def compute(input, part2: false)
    @part2 = part2
    seeds, maps = clean_input(input)
    @part2 ? traverse2(seeds, maps) : traverse(seeds, maps)
  end

  private

  def clean_input(input)
    maps = input.split("\n\n")
    part1_seeds = maps.shift[6..].scan(/\d+/).map!(&:to_i)
    part2_seeds = part1_seeds.each_slice(2).to_a
    part2_seeds.map! { |pair| pair[0]..(pair[0] + pair[1] - 1) }

    maps.map! do |map|
      lines = map.split("\n")
      lines.shift
      ranges = []

      lines.each do |line|
        data = line.split(' ')
        data.map!(&:to_i)
        ranges << [data[1], data[0], data[2]]
      end
      ranges
    end
    seeds = @part2 ? part2_seeds : part1_seeds
    [seeds, maps]
  end

  def traverse(seeds, maps)
    locations = []
    seeds.each do |value|
      maps.each do |map|
        map.each do |range|
          input_range = range[0]..(range[0] + range[2] - 1)
          if input_range.include?(value)
            value = range[1] + (value - range[0])
            break
          end
        end
      end
      locations << value
    end

    locations.min
  end

  def traverse2(seed_ranges, maps)
    maps.each do |map|
      converted_ranges = []
      until seed_ranges.empty?
        seed_range = seed_ranges.shift

        map_ranges = map.map do |range_codes|
          input_range = range_codes[0]..(range_codes[0] + range_codes[2] - 1)
          output_range = range_codes[1]..(range_codes[1] + range_codes[2] - 1)
          [input_range, output_range]
        end

        map_ranges.each_with_index do |range, i|
          intersect = [seed_range.min, range[0].min].max..[seed_range.max, range[0].max].min
          unless intersect.min.nil?
            left = seed_range.min == intersect.min ? nil : seed_range.min..(intersect.min - 1)
            right = seed_range.max == intersect.max ? nil : (intersect.max + 1)..seed_range.max

            converted_ranges << in_to_out(intersect, range)
            seed_ranges << left unless left.nil?
            seed_ranges << right unless right.nil?
            break
          end

          converted_ranges << seed_range if i == map_ranges.length - 1
        end
      end
      seed_ranges = converted_ranges
    end

    seed_ranges.min_by(&:min).min
  end

  def in_to_out(intersect, range)
    low_diff = intersect.min - range[0].min
    high_diff = range[0].max - intersect.max
    min = range[1].min + low_diff
    max = range[1].max - high_diff
    min..max
  end
end

day = Day5.new

# p day.compute(SAMPLE)
# p day.compute(MAIN)

# p day.compute(SAMPLE, part2: true)
p day.compute(MAIN, part2: true)
