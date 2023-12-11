# frozen_string_literal: true

require './inputs/day11_input'
include Day11Input

# AoC Day11
class Day11
  def compute(input, part2: false)
    input = clean_input(input)
    expanded = expand_universe(input)
    galaxies = get_galaxies(expanded)
    shortest_path(galaxies)
  end

  private

  def clean_input(input)
    input.split("\n").map(&:chars)
  end

  def create_pairs(galaxies)
    all_pairs = galaxies.permutation(2).to_a
  end

  def expand_universe(input)
    row_indexes = []
    col_indexes = []
    input.each_with_index { |line, i| row_indexes << i if line.all?('.') }
    rotated = input.transpose.map(&:reverse)
    rotated.each_with_index { |line, i| col_indexes << i if line.all?('.') }

    row_indexes.each_with_index do |row_i, i|
      input.insert(row_i + i, ['.'] * input.first.length)
    end

    input.each do |line|
      col_indexes.each_with_index do |char_i, i|
        line.insert(char_i + i, '.')
      end
    end
    input
  end

  def get_galaxies(input)
    galaxies = []
    input.each_with_index do |line, row|
      start = 0

      Kernel.loop do
        break if start > line.length - 1 || line[start..].none?('#')

        col = line[start..].index('#')
        galaxies << [row, col + start]
        start = col + start + 1
      end
    end
    galaxies
  end

  def shortest_path(galaxies)
    distances = []
    completed_pairs = []
    pairs = create_pairs(galaxies)
    pairs.each_with_index do |pair, i|
      next if completed_pairs.any? { |p| p == pair.reverse }

      distances << (pair[0][0] - pair[1][0]).abs + (pair[0][1] - pair[1][1]).abs
      completed_pairs << pair
    end

    distances.sum
  end
end

day = Day11.new

# p day.compute(SAMPLE)
p day.compute(MAIN)

# p day.compute(SAMPLE, part2: true)
# p day.compute(MAIN, part2: true)
