# frozen_string_literal: true

require './inputs/day6_input'
include Day6Input

# AoC Day6
class Day6
  def compute(input, part2: false)
    win_totals = []
    times, distances = clean_input(input)

    times.each_with_index do |time, race|
      wins = 0
      time.times do |i|
        next if i.zero?

        remaining = time - i
        distance = remaining * i
        wins += 1 if distance > distances[race]
      end
      win_totals << wins
    end

    win_totals.reduce(&:*)
  end

  private

  def clean_input(input)
    all_nums = input.scan(/\d+/).map(&:to_i)
    all_nums.each_slice(all_nums.length / 2).to_a
  end
end

day = Day6.new

# p day.compute(SAMPLE)
# p day.compute(MAIN)

# p day.compute(SAMPLE2, part2: true)
p day.compute(MAIN2, part2: true)
