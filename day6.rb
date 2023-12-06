# frozen_string_literal: true

SAMPLE_INPUT =
"Time:      7  15   30
Distance:  9  40  200
"

MY_INPUT =
"Time:        41     77     70     96
Distance:   249   1362   1127   1011
"

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

# p day.compute(SAMPLE_INPUT)
p day.compute(MY_INPUT)

# p day.compute(SAMPLE_INPUT, part2: true)
# p day.compute(MY_INPUT, part2: true)
