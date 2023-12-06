# frozen_string_literal: true

require './inputs/day2_input'
include Day2Input

PART_ONE_PARAMS = { r: 12, g: 13, b: 14 }.freeze

# AoC Day2
class Day2
  def compute(input, part2: false)
    @games = []
    @indexes = []
    @powers = []

    clean_input(input)
    part2 ? sum_of_powers : sum_of_indexes
  end

  private

  def clean_input(input)
    input.each_line do |line|
      game_maxes = { r: [], g: [], b: [] }
      color_nums = line.scan(/\d+\s[rgb]/) # ["3 g", "15 r", ...]
      color_nums.each { |str| game_maxes[str[-1].to_sym].push(str[0...-2].to_i) }
      @games << game_maxes.transform_values(&:max)
    end
  end

  def sum_of_indexes
    @games.each_with_index do |game, index|
      @indexes.push(index + 1) if game.all? { |color, num| PART_ONE_PARAMS[color] >= num }
    end
    @indexes.sum
  end

  def sum_of_powers
    @games.each do |game|
      power = 1
      game.each { |_, blocks| power *= blocks }
      @powers.push(power)
    end
    @powers.sum
  end
end

day2 = Day2.new
# p day2.compute(SAMPLE)
# p day2.compute(MAIN)

# p day2.compute(SAMPLE, part2: true)
p day2.compute(MAIN, part2: true)
