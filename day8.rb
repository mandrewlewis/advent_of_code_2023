# frozen_string_literal: true

require './inputs/day8_input'
include Day8Input

# AoC Day8
class Day8
  def compute(input, part2: false)
    count = 0
    pointer = 'AAA'
    @nodes = {}
    directions = clean_input(input)

    Kernel.loop do
      directions.chars.each do |direction|
        count += 1
        pointer = direction == 'L' ? @nodes[pointer][0] : @nodes[pointer][1]
        break if pointer == 'ZZZ'
      end
      break if pointer == 'ZZZ'
    end
    count
  end

  private

  def clean_input(input)
    lines = input.split("\n")
    directions = lines.shift
    maps = lines[1..].map { |line| line.scan(/[A-Z]+/) }
    maps.each do |map|
      @nodes[map[0]] = [map[1], map[2]]
    end
    directions
  end
end

day = Day8.new

# p day.compute(SAMPLE)
p day.compute(MAIN)

# p day.compute(SAMPLE, part2: true)
# p day.compute(MAIN, part2: true)
